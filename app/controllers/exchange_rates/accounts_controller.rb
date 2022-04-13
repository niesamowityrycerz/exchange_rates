module ExchangeRates
  class AccountsController < ApplicationController

    def convert
      service_response = NbpExternalService::CurrencyExchange.new(params.permit!).call
      render json: service_response
    end

  end
end