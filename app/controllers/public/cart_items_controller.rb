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
      # 数量選択しなかったら、商品詳細ページにrenderで
    if params[:cart_item][:product_id].blank?
      @product = Product.find(cart_item.product_id)
      @cart_item = CartItem.new
      flash[:notice] = "個数を選択してください"
      render :"public/products/show"
    end

    if current_customer.cart_items.find_by(product_id: params[:cart_item][:product_id]).nil?
      cart_item = CartItem.new(cart_item_params)
      cart_item.customer_id = current_customer.id
      cart_item.save
    else
      cart_item = current_customer.cart_items.find_by(product_id: params[:cart_item][:product_id])
      quantity = cart_item.quantity + params[:cart_item][:quantity].to_i
      cart_item.update(quantity: quantity)
    end
      flash[:notice] = "#{cart_item.product.name}をカートに追加しました"
      redirect_to cart_items_path
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id)
  end

end
