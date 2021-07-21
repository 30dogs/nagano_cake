class Public::CartItemsController < ApplicationController

  def show
  end

  def destroy_all
  end

  def destroy
  end

  def index
    @cart_items = CartItem.where(customer_id: current_customer)
  end

  def update
  end

  def create
    cart_item = CartItem.new(cart_item_params)
    cart_item.customer_id = current_customer.id
    # product_idはどうやって拾うのか
    p cart_item
    if cart_item.save
      redirect_to cart_items_path
    else
      render :"products/show"
    end
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id)
  end

end
