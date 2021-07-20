class Admin::GenresController < ApplicationController
  def index
    @genre = Genre.new
    @genres = Genre.all.page(params[:page]).per(10)
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
  end

  def create
  end
  
  private

  def genre_params
    params.require(:genre).permit(:name, :is_valid)
  end

  
end
