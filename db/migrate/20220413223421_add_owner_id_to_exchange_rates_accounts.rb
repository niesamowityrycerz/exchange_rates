class AddOwnerIdToExchangeRatesAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :exchange_rates_accounts, :owner_id, :integer
  end
end
