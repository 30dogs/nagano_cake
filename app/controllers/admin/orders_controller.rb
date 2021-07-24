class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @orders = Order.page(params[:page]).reverse_order
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(product_params)
      flash[:success] = "製作ステータスを更新しました"
      redirect_to request.referer
    end
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

