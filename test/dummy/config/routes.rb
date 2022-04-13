Rails.application.routes.draw do
  mount ExchangeRates::Engine => "/exchange_rates"
end
