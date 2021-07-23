class Public::OrdersController < ApplicationController
  # [目的]confirmアクションとfinishアクションに関して、遷移前のページが指定した条件のURLでない場合は、別のページに遷移させる
  # やらなかったからと言って問題は起こらないので、別に必要はない。
  # before_action :check_confirm, only: [:confirm]
  before_action :check_finish, only: [:finish]

  # confirmアクションが行われる前に以下のアクションを実行させる
  # def check_confirm
  #   # 遷移前のページのURLに「/orders/new」を含まない場合は、「/cart_items」に遷移させる
  #   unless request.referer&.include?("/orders/new")
  #     redirect_to cart_items_path
  #   end
  # end

  # finishアクションが行われる前に以下のアクションを実行させる
  def check_finish
    # 遷移前のページのURLに「/orders/confirm」を含まない場合は、「/cart_items」に遷移させる
    unless request.referer&.include?("/orders/confirm")
      redirect_to root_path
    end
  end

  def index
    #odersテーブルのレコードをすべて取得する
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
    @order_items = OrderItem.where(order_id: @order.id)
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
    @order = Order.new(order_params)
    # 注文内容のレコードを保存する。
    @order.save
    # カート内商品のデータを削除をする。
    current_customer.cart_items.destroy_all
    redirect_to finish_orders_path
  end

  def confirm
    #Orderクラスのインスタンスを生成する
    @order = Order.new

    #@orderのそれぞれのカラムに値を代入していく
    #@orderのcustomer_idに現在ログインしている会員のidの値を代入する
    @order.customer_id = current_customer.id
    #params[:delivery]の値を条件にしてif文を作る。
    #params[:delivery]はラジオボタンから受け取ったパラメータである。
    #「ご自身の住所」を選択した場合、params[:delivery]の値は1
    #「登録済住所から選択」を選択した場合、params[:delivery]の値は2
    #「新しいお届け先」を選択した場合、params[:delivery]の値は3となっている。
    if params[:delivery] == "1"
      #@orderに現在ログインしている会員のaddress,postcode,nameを代入する。
      @order.address = current_customer.address
      @order.postcode = current_customer.postcode
      @order.name = current_customer.full_name
    elsif params[:delivery] == "2"
      #params[:sellect_delivery]はセレクトで選択した情報が保管されている、deliveriesテーブルのレコ―ドのidである。
      delivery = Delivery.find(params[:sellect_delivery].to_i)
      #@orderにdeliveryのaddress,postcode,nameを代入する。
      @order.address = delivery.address
      @order.postcode = delivery.postcode
      @order.name = delivery.name
    elsif params[:delivery] == "3"
      #@orderにパラメータで受け取った:address,:postcode,:nameを代入する。
      @order.address = params[:address]
      @order.postcode = params[:pastcode]
      @order.name = params[:name]
    end
    #@orderのpay_methodにパラメータで受け取った:pay_methodを代入する
    # paramsで受け取った値はstring型になっているので、to_iメソッドでinteger型にする
    @order.payment_method = params[:payment_method].to_i
    @order.postage = 800

    @cart_item_total = current_customer.total
    #請求金額を求める。
    #カート内の合計金額に送料を加える。
    @order.billing_total = @cart_item_total + @order.postage
    # くまさんより - 89行名 "biling_total" → "billing_total" へ編集しました!!

    #cart_itemsテーブルの中のcustomer_idが現在ログインしている会員のidと同じ値のレコードを取得する。
    @cart_items = current_customer.cart_items

    if @order.invalid?
      # new.html.erbで必要な変数を宣言する　ここから
      #customersテーブルの、ログインしている会員のレコードを取り出す。
      @customer = current_customer
      #deliveriesテーブルの、ログインしている会員が登録した配送先のレコードを取り出す。
      deliveries = current_customer.deliveries
      #配列をつくるために、Arrayクラスのインスタンスを生成する。
      @array_deliveries = Array.new
      #eachメソッドでdeliveriesからレコードを一つずつ取り出して、繰り返し処理を行う。
      deliveries.each do |delivery|
        #レコードの値を取り出していく。
        postcode = delivery.postcode
        address = delivery.address
        name = delivery.name
        #変数展開を使って、取り出した値を結合させて文字列にする。
        delivery_info = "〒#{postcode} #{address} #{name}"
        #配列をつくるために、Arrayクラスのインスタンスを生成する。
        array_delivery = Array.new
        #配列array_deliveryに文字列delivery_infoと数値delivery.idを要素として追加する。
        array_delivery.push(delivery_info, delivery.id)
        #配列@array_deliveriesに配列array_deliveryを要素として追加する。
        @array_deliveries.push(array_delivery)
      end
      # 入力した値を再びフォームに表示させるための変数を宣言する。　ここから
      @postcode = params[:postcode]
      @address = params[:address]
      @name = params[:name]
      if params[:payment_method] == "0"
        @payment_method_0 = true
      elsif params[:payment_method] == "1"
        @payment_method_1 = true
      end
      if params[:delivery] == "1"
        @delivery = true
      elsif params[:delivery] == "2"
        @delivery = true
      elsif params[:delivery] == "3"
        @delivery = true
      end
      # 入力した値を再びフォームに表示させるための変数を宣言する。　ここから
      # new.html.erbで必要な変数を宣言する　ここまで

      render :new
    end
  end

  private
  def order_params
    params.require(:order).permit(:customer_id, :name, :postcode, :address, :postage, :billing_total, :payment_method)
  end

end
