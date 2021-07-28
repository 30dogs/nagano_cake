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
  validates :kana_first_name, presence: {message: 'カタカナで入力して下さい。'}, format: { with: /\A[ｧ-ﾝﾞﾟァ-ヶー－]+\z/ }
  validates :kana_last_name, presence: {message: 'カタカナで入力して下さい。'}, format: { with: /\A[ｧ-ﾝﾞﾟァ-ヶー－]+\z/ }
  validates :postcode, presence: true
  validates :address, presence: true
  validates :phone_number,  presence: true

  # statusに関するenum記述
  # ↓enumではなくてbooleanなのでここに書くとエラーになるのでコメントアウトしました
  # enum is_deleted: { 有効: false, 無効: true }

  # ログインする時に退会済み(is_deleted==true)のユーザーを弾くためのメソッドを作成します。
  # super && (self.is_deleted == false)で、customerのis_deletedがfalseならtrueを返すようにしています。
  def active_for_authentication?
    super && (self.is_deleted == false)
  end

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
    return (self.base_price_subtotal(product_id) * 1.08)
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

  #くまさん追記 / 07/27 14:10
  # カートアイテムでの数字の表示を直すためのもの
  def subtotal2(product_id)
    return (self.base_price_subtotal(product_id) * 1.08).floor.to_s(:delimited, delimiter: ',')
  end

  #くまさん追記 / 07/27 14:10
  # カートアイテムでの数字の表示を直すためのもの
  def total2
    cart_items = self.cart_items
    #カート内の税抜きの合計金額を繰り返し処理で求める。
    base_price_total = 0
    cart_items.each do |cart_item|
      base_price_total += cart_item.product.base_price * cart_item.quantity
    end
    #税抜きの合計金額に消費税を加える。
    return  (base_price_total * 1.08).floor.to_s(:delimited, delimiter: ',')
  end
end
