class Admin::GenresController < ApplicationController
  def index
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
  end

  def create
  end
end
