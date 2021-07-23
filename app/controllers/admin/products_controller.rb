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
    if @product.update(product_params)
      flash[:success] = "商品内容をを変更しました"
      redirect_to admin_product_path(@product)
    else
      render :edit
    end
  end

  def create
  end
  
  def product_params
    params.require(:product).permit(
      :genre_id, 
      :name, 
      :description, 
      :base_price, 
      :product_image_id, 
      :sale_status
      )
  end
end
