class Derivery < ApplicationRecord
  belongs_to :customer

  validates :name, presence: true
  validates :postcode, presence: true
  validates :address, presence: true
end
