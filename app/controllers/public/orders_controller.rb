class Public::OrdersController < ApplicationController

  before_action :authenticate_customer!

  # [目的]confirmアクションとfinishアクションに関して、遷移前のページが指定した条件のURLでない場合は、別のページに遷移させる。
  # やらなかったからと言って問題は起こらないので、別に必要はない。
  # before_action :check_confirm, only: [:confirm]
  # before_action :check_finish, only: [:finish]

  # [目的]　カート内に商品がなくても注文できてしまうことを避けるために、
  # 　　　　カート内商品がない場合には、newアクション、createアクション、confirmアクションを実行できないようにしました。
  before_action :check_cart_item, only: [:new, :create, :confirm]

  # confirmアクションが行われる前に以下のアクションを実行させる
  # def check_confirm
  #   # 遷移前のページのURLに「/orders/new」を含まない場合は、「/cart_items」に遷移させる
  #   unless request.referer&.include?("/orders/new")
  #     redirect_to cart_items_path
  #   end
  # end

  # finishアクションが行われる前に以下のアクションを実行させる
  # def check_finish
  #   # 遷移前のページのURLに「/orders/confirm」を含まない場合は、「/」に遷移させる
  #   unless request.referer&.include?("/orders/confirm")
  #     redirect_to root_path
  #   end
  # end

  # newアクションが行われる前に以下のアクションを実行させる。
  def check_cart_item
    unless current_customer.cart_items.exists?
      # falshメッセージを表示させる。
      flash[:notice] = "カートに商品がないので注文できません"
      # redirect_toで遷移先を指定する。
      redirect_to root_path
    end
  end

  def index
    #odersテーブルのレコードをすべて取得する
    @orders = current_customer.orders.page(params[:page]).reverse_order
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
      @payment_method_0 = true
  end

  def finish
  end

  def create
    # Orderクラスのインスタンスを生成する。
    order = Order.new(order_params)
    # ordersテーブルにデータを保存する。
    order.save
    # [目的] 注文商品テーブルに注文した商品を保存する。
    cart_items = current_customer.cart_items
    cart_items.each do |cart_item|
      # OrderItemクラスのインスタンスを生成して、値を代入する。
      order_item = OrderItem.new(order_id: order.id, product_id: cart_item.product.id, quantity: cart_item.quantity, purchase_price: cart_item.product.base_price)
      # order_itemsテーブルにデータを保存する。
      order_item.save
    end
    # カート内商品のデータをすべて削除をする。
    current_customer.cart_items.destroy_all
    # redirect_toで遷移先を指定する。
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
      # [目的] params[:sellect_delivery]が「空の配列」のとき、@orderに値を代入しない。
      #「blank?」は「nil」に加えて「空白文字列」「空の配列」なども「true」が返却され、
      #　それ以外の実際に値が設定されている場合には「false」が返却される。
      unless params[:sellect_delivery].blank?
        #params[:sellect_delivery]はセレクトで選択した情報が保管されている、deliveriesテーブルのレコ―ドのidである。
        delivery = Delivery.find(params[:sellect_delivery].to_i)
        #@orderにdeliveryのaddress,postcode,nameを代入する。
        @order.address = delivery.address
        @order.postcode = delivery.postcode
        @order.name = delivery.name
      end
    elsif params[:delivery] == "3"
      #@orderにパラメータで受け取った:address,:postcode,:nameを代入する。
      @order.address = params[:address]
      @order.postcode = params[:postcode]
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

    #cart_itemsテーブルの中のcustomer_idが現在ログインしている会員のidと同じ値のレコードを取得する。
    @cart_items = current_customer.cart_items

    # バリエーションのエラーがあるかどうかを調べる。
    # エラーがあれば、trueが返され、new.html.erbに遷移させる。
    if @order.invalid?
      # new.html.erbで必要な変数を宣言する。　ここから
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
      # 入力した値を再びpublic/orders/new.html.erbのフォームに表示させるための変数を宣言する。　ここから
      @postcode = params[:postcode]
      @address = params[:address]
      @name = params[:name]
      if params[:payment_method] == "0"
        @payment_method_0 = true
      elsif params[:payment_method] == "1"
        @payment_method_1 = true
      end
      if params[:delivery] == "1"
        @delivery_1 = true
      elsif params[:delivery] == "2"
        @delivery_2 = true
      elsif params[:delivery] == "3"
        @delivery_3 = true
      end
      # 入力した値を再びpublic/orders/new.html.erbのフォームに表示させるための変数を宣言する。　ここまで
      # new.html.erbで必要な変数を宣言する。　ここまで
      # renderで遷移先を指定する。
      render :new
    end
  end

  private
  def order_params
    params.require(:order).permit(:customer_id, :name, :postcode, :address, :postage, :billing_total, :payment_method)
  end

end
