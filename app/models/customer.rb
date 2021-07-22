class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :deliveries, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :orders

  has_many :products, through: :cart_items

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :first_name_kana, presence: {message: 'カタカナで入力して下さい。'}, format: { with: /\A[ｧ-ﾝﾞﾟァ-ヶー－]+\z/ }
  validates :last_name_kana, presence: {message: 'カタカナで入力して下さい。'}, format: { with: /\A[ｧ-ﾝﾞﾟァ-ヶー－]+\z/ }
  validates :postcode, presence: {message: '7桁で入力してください。'}, format: { with: /\A\d{7}\z/ }
  validates :address, presence: true
  validates :phone_number,  presence: {message: '10桁もしくは11桁で入力してください。'}, format: { with: /\A\d{10,11}\z/ }


  # statusに関するenum記述
  enum is_deleted: { 有効: false, 無効: true }

  # 会員フルネーム
  def full_name
    self.last_name + " " + self.first_name
  end
  # 会員フルネーム(カナ)
  def full_name_kana
    self.last_name_kana + " " + self.first_name_kana
  end

  #カート内商品小計(税抜き価格)を返すメソッド
  def base_price_subtotal(product_id)
    product = Product.find(product_id)
    cart_item = self.cart_items.find_by(product_id: product_id)
    base_price_total = product.base_price * cart_item.quantity
    return base_price_total
  end

  #カート内商品小計(税込み価格)を返すメソッド
  def subtotal(product_id)
    return (self.base_price_subtotal(product_id) * 1.08).floor
  end

  # カート内商品合計金額を返すメソッド
  def total
    cart_items = self.cart_items
    #カート内の税抜きの合計金額を繰り返し処理で求める。
    base_price_total = 0
    cart_items.each do |cart_item|
      base_price_total += cart_item.product.base_price * cart_item.quantity
    end
    #税抜きの合計金額に消費税を加える。
    return  (base_price_total * 1.08).floor
  end


end
