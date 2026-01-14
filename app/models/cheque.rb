class Cheque < ApplicationRecord
  belongs_to :bordero

  monetize :value, as: :amount

  enum :status, {
    awaiting: "awaiting",
    deposited: "deposited",
    awaiting_clearance: "awaiting_clearance",
    refused: "refused",
    paid: "paid"
  }, default: :awaiting
end
