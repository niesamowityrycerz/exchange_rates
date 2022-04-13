module ExchangeRates
  class AccountsController < ApplicationController

    def convert
      service_response = NbpExternalService::CurrencyExchange.new(params.permit!.to_h).call
      if service_response[:status] == 'success'
        render json: service_response, status: 200
      else
        render json: service_response, status: 400
      end
    end

  end
end