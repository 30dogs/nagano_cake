class Order < ApplicationRecord
  belongs_to :customer

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :name, presence: true
  validates :postcode, presence: true
  validates :address, presence: true
  validates :postage, presence: true
  validates :billing_total, presence: true
  validates :payment_method, presence: true
  validates :status, presence: true
end
