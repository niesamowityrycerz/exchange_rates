class CreateExchangeRatesAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_rates_accounts do |t|
      t.decimal :total_orders_pln, precision: 11, scale: 2
      t.decimal :total_orders_eur, precision: 11, scale: 2

      t.timestamps
    end
  end
end
