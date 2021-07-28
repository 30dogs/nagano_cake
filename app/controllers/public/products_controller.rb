class Public::ProductsController < ApplicationController

  def index
    @products = Product.page(params[:page]).reverse_order.per(8)
    @genres = Genre.all
  end

  def show
    @product = Product.find(params[:id])
    @cart_item = CartItem.new
    @genres = Genre.all
  end

end
