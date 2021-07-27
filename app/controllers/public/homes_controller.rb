class Public::HomesController < ApplicationController

  def top
    @products = Product.all
    @genres = Genre.all
  end

  def about
  end

end
