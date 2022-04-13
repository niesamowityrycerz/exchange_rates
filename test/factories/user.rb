FactoryBot.define do
  factory :user, class: 'User' do
    name { 'Test name'  }
    email  { 'test@gmail.com' }
    total_orders_pln { rand(User::MIN_TOTAL_ORDERS_PLN..User::MAX_TOTAL_ORDERS_PLN) }
    total_orders_eur { 0 }
  end
end