class Public::ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
  end
end
