class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true
  validates :purchase_price, presence: true

  # 製作ステータスに関するenum記述
  enum making_status: { 着手不可: 0, 製作待ち: 1, 製作中: 2, 製作完了: 3 }

  # 各商品小計(購入時価格 * 個数)
  def sub_total_price
    purchase_price * quantity
  end

  def product_total_price
  end

end
