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
  validates :sale_status, inclusion: { in: [true, false] }

  # 商品の税込み価格を返すメソッド
  def price
    return (self.base_price * 1.08).floor
  end

  # 商品の税込価格を計算し、3桁毎に","で区切ったものを返す
  def tax_in_price
    floor_price = (base_price * 1.08).floor
    floor_price.to_s(:delimited, delimiter: ',')
  end

  # 商品の税抜価格を計算し、3桁毎に","で区切ったものを返す
  def no_tax_price
    floor_price = base_price.floor
    floor_price.to_s(:delimited, delimiter: ',')
  end

end
