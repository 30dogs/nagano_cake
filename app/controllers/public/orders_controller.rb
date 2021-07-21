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
    #Orderクラスのインスタンスを生成する
    @order = Order.new()

    #@orderのそれぞれのカラムに値を代入していく
    #@orderのcustomer_idに現在ログインしている会員のidの値を代入する
    @order.customer_id = current_customer.id
    #params[:delivery]の値を条件にしてif文を作る。
    #params[:delivery]はラジオボタンから受け取ったパラメータである。
    #「ご自身の住所」を選択した場合、params[:delivery]の値は1
    #「登録済住所から選択」を選択した場合、params[:delivery]の値は2
    #「新しいお届け先」を選択した場合、params[:delivery]の値は3となっている。
    if params[:delivery] = 1
      #@orderに現在ログインしている会員のaddress,postcode,nameを代入する。
      @order.address = current_customer.address
      @order.postcode = current_customer.postcode
      @order.name = current_customer.name
    elsif params[:delivery] = 2
      #params[:sellect_delivery]はセレクトで選択した情報が保管されている、deliveriesテーブルのレコ―ドのidである。
      delivery = Delivery.find(params[:sellect_delivery])
      #@orderにdeliveryのaddress,postcode,nameを代入する。
      @order.address = delivery.address
      @order.postcode = delivery.postcode
      @order.name = delivery.name
    elsif params[:delivery] = 3
      #@orderにパラメータで受け取った:address,:postcode,:nameを代入する。
      @order.address = params[:address]
      @order.postcode = params[:pastcode]
      @order.name = params[:name]
    end
    #@orderのpay_methodにパラメータで受け取った:pay_methodを代入する
    @order.pay_method = params[:pay_method]
    @order.postage = 800

    # #カート内の税抜きの合計金額を繰り返し処理で求める。
    # @cart_item_base_price_totall = 0
    # cart_items = current_customer.cart_items
    # cart_items.each do |cart_items|
    #   @cart_item_base_price_totall += cart_item.product.base_price * cart_item.quantity
    # end

    # #カート内の税抜きの合計金額に消費税を加える。
    # @cart_item_totall = (@cart_item_base_price_totall * 1.08).floor

    @cart_item_totall = current_customer.total
    #請求金額を求める。
    #カート内の合計金額に送料を加える。
    @order.biling_total = @cart_item_totall + @order.postage

    #cart_itemsテーブルの中のcustomer_idが現在ログインしている会員のidと同じ値のレコードを取得する。
    @cart_items = current_customer.cart_items
  end

end
