class Public::OrdersController < ApplicationController

  def index
    #odersテーブルのレコードをすべて取得する
    @orders = Order.all
  end

  def show
  end

  def new
    #customersテーブルの、ログインしている会員のレコード
    @customer = current_customer
    #deliveriesテーブルの、ログインしている会員が登録した配送先のレコード
    deliveries = current_customer.deliveries
    #配列をつくるために、Arrayクラスのインスタンスを生成
    @array_deliveries = Array.new
    #eachメソッドでdeliveriesからレコードを一つずつ取り出して、繰り返し処理を行う
    deliveries.each do |delivery|
      #レコードの値を取り出していく
      postcode = delivery.postcode
      address = delivery.address
      name = delivery.name
      #変数展開を使って、取り出した値を結合させて文字列にする
      delivery_info = "〒#{postcode} #{address} #{name}"
      #配列をつくるために、Arrayクラスのインスタンスを生成
      array_delivery = Array.new
      #配列array_deliveryに文字列delivery_infoと数値delivery.idを要素として追加する
      array_delivery.push(delivery_info, delivery.id)
      #配列@array_deliveriesに配列array_deliveryを要素として追加する
      @array_deliveries.push(array_delivery)
    end
  end

  def finish
  end

  def create
  end

  def confirm
  end

end
