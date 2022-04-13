module ExchangeRates
  class Account < ApplicationRecord

    belongs_to :owner, class_name: "User"

    attr_accessor :owner_id
    before_validation :set_owner

    private

    def set_owner
      self.owner = User.find(owner_id || id)
    end
  end
end
