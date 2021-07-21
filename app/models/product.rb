class Product < ApplicationRecord

  belongs_to :genre

  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :customers, through: :cart_items
  has_many :orders, through: :order_items

  attachment :product_image

  validates :name, presence: true
  validates :description, presence: true
  validates :base_price, presence: true
  validates :product_image, presence: true
  validates :sale_status, presence: true

  # 商品の税込み価格を返すメソッド
  def price
    return (self.base_price * 1.08).floor
  end
end
