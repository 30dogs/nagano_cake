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

end
