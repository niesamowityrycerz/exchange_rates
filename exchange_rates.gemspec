require_relative "lib/exchange_rates/version"

Gem::Specification.new do |spec|
  spec.name        = "exchange_rates"
  spec.version     = ExchangeRates::VERSION
  spec.authors     = ["Lukasz Winek"]
  spec.summary     = "Calculate exchage rates"
  spec.description = "Calculate exchage rates"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.2.3"
  spec.add_dependency "http"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "webmock"
end
