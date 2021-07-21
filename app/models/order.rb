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


  # statusに関するenum記述
  enum status: { 入金待ち: 0, 入金確認中: 1, 製作中: 2, 発送準備中: 3, 発送済み: 4 }
end
