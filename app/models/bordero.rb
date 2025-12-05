class Bordero < ApplicationRecord
  has_many :cheques, dependent: :destroy

  accepts_nested_attributes_for :cheques

  validates :data_troca, presence: true
  validates :juros_mensal, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
