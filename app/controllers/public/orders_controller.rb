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
    @order = Order.new()
    @order.customer_id = current_customer.id
    
    if params[:delivery] = 1
      @order.address = current_customer.address
      @order.postcode = current_customer.postcode
      @order.name = current_customer.name
    elsif params[:delivery] = 2
      delivery = Delivery.find(params[:sellect_delivery])
      @order.address = delivery.address
      @order.postcode = delivery.postcode
      @order.name = delivery.name
    elsif params[:delivery] = 3
      @order.address = params[:address]
      @order.postcode = params[:pastcode]
      @order.name = params[:name]
    end
      
    @order.pay_method = params[:pay_method]
    @order.postage = 800
    
    @cart_item_base_price_totall = 0
    cart_items = current_customer.cart_items
    cart_items.each do |cart_items|
      @cart_item_base_price_totall += cart_item.product.base_price
    end
    
    @cart_item_totall = (@cart_item_base_price_totall * 1.08).floor
    
    @order.biling_total = @cart_item_totall + @order.postage
    
    @cart_items = current_customer.cart_items
  end

end
