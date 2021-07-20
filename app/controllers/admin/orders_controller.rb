class Admin::OrdersController < ApplicationController
  def index
  end

  def show
    @customer = current_customer
  end

  def update
  end
end
