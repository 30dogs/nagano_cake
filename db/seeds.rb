# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~ターミナルで"rails db:reset"で使用~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ここからAdminアカウント作成
Admin.create!(
  email: "test@test",
  password: "test@test",
)
# ここまでAdminアカウント作成

# ここからCustomerアカウント作成
5.times do |number|
  Customer.create!(
    email: "test@test#{number + 1}",
    password: "test@test#{number + 1}",
    last_name: "姓#{number + 1}",
    first_name: "名#{number + 1}",
    last_name_kana: "セイ",
    first_name_kana: "メイ",
    postcode: "0000000",
    address: "住所#{number + 1}",
    phone_number: "0900000000#{number + 1}",
    is_deleted: "false"
  )
end
# # ここまでCustomerアカウント作成

# # ここからGenres作成
5.times do |number|
  Genre.create(name: "#{number + 1}")
end
# # ここまでGenres作成

# # ここからproduct作成
20.times do |number|
  Product.create!(
    genre_id: "1",
    name: "product#{number + 1}",
    description: "description#{number + 1}",
    base_price: "#{number + 1}",
    product_image: File.open("app/assets/images/no_image_kuma.jpg"),
    sale_status: "True"
  )
end
# # ここまでproduct作成

# # ここからorder作成
50.times do |number|
  Order.create!(
    customer_id: "1",
    name: "test@test#{number + 1}",
    postcode: "0000000",
    address: "住所",
    # くまさん_要件定義に従い 700円 → 800円 へ変更
    postage: "800",
    billing_total: "#{number + 1}",
    payment_method: "銀行振込",
    status: "入金待ち"
    )
end
# # ここまでorder作成

# # 7/21 12:55 くまさん追記_order_itemを作成する"seed"をテスト用で記述
# # ここからorder_item作成
3.times do |number|
  OrderItem.create!(
    order_id: "1",
    product_id: "#{number + 1}",
    quantity: "1",
    purchase_price: "1000",
    making_status: "着手不可"
    )
end
# # ここまでorder_item作成


