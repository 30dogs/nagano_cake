class Admin::ProductsController < ApplicationController
   before_action :authenticate_admin!

  def index
    @products = Product.all.page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit

  end

  def new
    @genres = Genre.all
    @product = Product.new
  end

  def update
    @product = Product.find(params[:id])
  end

  def create
  end
end
