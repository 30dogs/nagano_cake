class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @orders = Order.page(params[:page]).reverse_order
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
  end
  
  private

  def order_params
    params.require(:order).permit(
      :name,
      :postcode,
      :address,
      :postage,
      :billing_total,
      :payment_method,
      :status
      )
  end
end
