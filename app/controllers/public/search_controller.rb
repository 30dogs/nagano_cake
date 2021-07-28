class Public::SearchController < ApplicationController

  def search
    @genres = Genre.all
    @value = params["value"] #value = genre.id
    @datas = match(@value).order(id: "DESC")
    @genre = Genre.find(@value)
  end

  private
  def match(value)
    Product.where(genre_id: value)
  end

end
