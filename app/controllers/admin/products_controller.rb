class Admin::ProductsController < ApplicationController
   before_action :authenticate_admin!

  def index
    @products = Product.all.page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
    @genres = Genre.all
  end

  def new
    @genres = Genre.all
    @product = Product.new
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_product_path(@product.id)
      flash[:success] = "商品を更新しました"
    end
  end

  def create
    product = Product.new(product_params)
    product.save
    redirect_to admin_product_path(product.id)
  end

  private
  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :product_image,
      :genre_id,
      :base_price,
      :sale_status
    )
  end
end

