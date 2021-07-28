class Admin::ProductsController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def new
  end

  def update
  end

  def create
    @product = Product.new(product_params)
    @genres = Genre.all
    if @product.save
      redirect_to admin_product_path(@product.id)
    else
      render action: :new
    end
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
