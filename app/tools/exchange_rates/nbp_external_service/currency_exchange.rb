module ExchangeRates
  module NbpExternalService
    class CurrencyExchange

      CURRENCY_OF_INTERESTS = "eur".freeze
      NBP_TABLE_TYPE = "a".freeze

      def initialize(input_params)
        @input_params = input_params
        @user = User.find(input_params[:id])
      end

      attr_reader :input_params, :user

      def call
        response = HTTP.get(uri)
        handler = ResponseHandler.new(response).call

        return handler[:error] if handler[:status] == 'failure'

        total_orders_eur = convert_total_orders_pln(handler[:rate])
        ActiveRecord::Base.transaction do
          update_user(total_orders_eur)
          create_exchange_rates_accont(total_orders_eur)
          prepared_response
        end
      end

      private

      def uri
        "http://api.nbp.pl/api/exchangerates/rates/#{NBP_TABLE_TYPE}/#{CURRENCY_OF_INTERESTS}/"
      end

      def convert_total_orders_pln(exchange_rate)
        user.total_orders_pln * exchange_rate
      end

      def update_user(total_orders_eur)
        user.update!(total_orders_eur: total_orders_eur)
      end

      def create_exchange_rates_accont(total_orders_eur)
        ExchangeRates::Account.new(total_orders_eur: total_orders_eur)
      end

      def prepared_response
        { user: user }
      end
    end
  end
end