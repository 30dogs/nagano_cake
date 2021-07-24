class Product < ApplicationRecord
  attachment :product_image

  belongs_to :genre

  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :customers, through: :cart_items
  has_many :orders, through: :order_items

  validates :name, presence: true
  validates :description, presence: true
  validates :base_price, presence: true
  validates :product_image_id, presence: true
  validates :sale_status, presence: true

end
