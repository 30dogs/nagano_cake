class Public::CartItemsController < ApplicationController

  def show
  end

  def destroy_all
    cart_items = CartItem.where(customer_id: current_customer.id)
    cart_items.each do |cart_item|
      cart_item.destroy
    end
    redirect_to cart_items_path
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.delete
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
    cart_item = CartItem.new(cart_item_params)
    cart_item.customer_id = current_customer.id
    if cart_item.save
      redirect_to cart_items_path
    else
      # 数量選択しなかったら、商品詳細ページにrenderで
      @product = Product.find(cart_item.product_id)
      @cart_item = CartItem.new
      render :"public/products/show"
    end
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id)
  end

end
