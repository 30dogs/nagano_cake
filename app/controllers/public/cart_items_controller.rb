class Public::CartItemsController < ApplicationController

  before_action :authenticate_customer!

  def show
  end

  def destroy_all
    cart_items = CartItem.where(customer_id: current_customer.id)
    cart_items.destroy_all
    flash[:notice] = "カートを空にしました"
    redirect_to cart_items_path
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.delete
    flash[:notice] = "#{cart_item.product.name}をカートから削除しました"
    redirect_to cart_items_path
  end

  def index
    @cart_items = CartItem.where(customer_id: current_customer)
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def create
    # 数量選択をしている場合としていない場合で分ける。
    # blank?は中身が空の時trueが返される。
    # [使い方] 変数.blank?
    # [解説] nil? + empty? のようなメソッド。nilまたは空のオブジェクトをチェック nil, “”, “ “(半角スペースのみ), 空の配列, 空のハッシュのときにfalseを返します Railsで拡張されたメソッドで、Rubyのみでは使えないのでご注意ください
    if params[:cart_item][:quantity].blank?
      # 数量を選択していない場合
      # 数量選択しなかったら、商品詳細ページにrenderで
      @product = Product.find(params[:cart_item][:product_id])
      @cart_item = CartItem.new
      flash[:notice] = "個数を選択してください"
      render :"public/products/show"
    else
      # 数量を選択している場合
      # cart_itemsテーブルの中にカラムのproduct_idが受け取ったproduct_idの値と同じレコードがあるかないかで場合を分ける。
      # nil?はオブジェクトが存在しない場合にtrueが返される。
      # [使い方] 変数.nil?
      # [解説] Rubyの標準メソッド。nilの場合のみtrueを返し、それ以外はfalse
      if current_customer.cart_items.find_by(product_id: params[:cart_item][:product_id]).nil?
        # オブジェクトががない場合
        cart_item = CartItem.new(cart_item_params)
        cart_item.customer_id = current_customer.id
        cart_item.save
      else
        # オブジェクトがある場合
        cart_item = current_customer.cart_items.find_by(product_id: params[:cart_item][:product_id])
        quantity = cart_item.quantity + params[:cart_item][:quantity].to_i
        cart_item.update(quantity: quantity)
      end
      flash[:notice] = "#{cart_item.product.name}をカートに追加しました"
      redirect_to cart_items_path
    end

  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id)
  end

end
