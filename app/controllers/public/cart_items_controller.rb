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
  end

end
