module ExchangeRates
  class Engine < ::Rails::Engine
    isolate_namespace ExchangeRates
    config.generators.api_only = true
  end
end
