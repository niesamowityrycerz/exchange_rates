require 'rails_helper'

RSpec.describe 'Exchange rates', type: :request do

  let!(:user) { create(:user) }

  context 'when happy path' do

    let(:total_orders_eur_before) { user.total_orders_eur }
    let(:rate)           { 4.646 }
    let(:example_body)   { {"table"=>"A", "currency"=>"euro", "code"=>"EUR", "rates"=>[{"no"=>"072/A/NBP/2022", "effectiveDate"=>"2022-04-13", "mid"=>rate}]}.to_json }
    let(:expected_value) { (user.total_orders_pln * rate).round(2)}

    before do
      stub_request(:get, "http://api.nbp.pl/api/exchangerates/rates/a/eur/")
        .with(
          headers: {
          'Connection'=>'close',
          'Host'=>'api.nbp.pl',
          'User-Agent'=>'http.rb/5.0.4'
          })
        .to_return(status: 200, body: example_body, headers: {})
    end

    let(:params) do
      {
        id: user.id,
      }
    end

    it 'calculates and store value' do
      get '/exchange_rates', params: params
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      expect(user.reload.total_orders_eur).to eq(expected_value)

      exchange_account = ExchangeRates::Account.last
      expect(exchange_account.total_orders_eur).to eq(expected_value)
      expect(exchange_account.total_orders_pln).to eq(user.total_orders_pln)
    end
  end

  context 'when external service unavailable' do

    before do
      stub_request(:get, "http://api.nbp.pl/api/exchangerates/rates/a/eur/")
        .with(
          headers: {
          'Connection'=>'close',
          'Host'=>'api.nbp.pl',
          'User-Agent'=>'http.rb/5.0.4'
          })
        .to_return(status: 500, body: '', headers: {})
    end

    it 'returns error' do
      get '/exchange_rates', params: {id: user.id}
      expect(response.status).to eq(400)
      parsed_body = JSON.parse(response.body)

      expect(parsed_body['status']).to eq('failure')
      expect(parsed_body['error']).to eq('Service is unavailable')
    end
  end

  context 'when invalid request' do

    before do
      stub_request(:get, "http://api.nbp.pl/api/exchangerates/rates/a/eur/")
        .with(
          headers: {
          'Connection'=>'close',
          'Host'=>'api.nbp.pl',
          'User-Agent'=>'http.rb/5.0.4'
          })
        .to_return(status: 400, body: '', headers: {})
    end

    it 'returns error' do
      get '/exchange_rates', params: {id: user.id}
      expect(response.status).to eq(400)
      parsed_body = JSON.parse(response.body)

      expect(parsed_body['status']).to eq('failure')
      expect(parsed_body['error']).to eq('Invalid request')
    end
  end

  context 'when missing data' do

    before do
      stub_request(:get, "http://api.nbp.pl/api/exchangerates/rates/a/eur/")
        .with(
          headers: {
          'Connection'=>'close',
          'Host'=>'api.nbp.pl',
          'User-Agent'=>'http.rb/5.0.4'
          })
        .to_return(status: 404, body: '', headers: {})
    end

    it 'returns error' do
      get '/exchange_rates', params: {id: user.id}
      expect(response.status).to eq(400)
      parsed_body = JSON.parse(response.body)

      expect(parsed_body['status']).to eq('failure')
      expect(parsed_body['error']).to eq('Service is missing data')
    end
  end
end