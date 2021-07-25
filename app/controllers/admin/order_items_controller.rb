class Admin::OrderItemsController < ApplicationController
  def update
    @order_item = OrderItem.find(params[:id])
    if @order_item.update(making_status: params[:order_item][:making_status].to_i)
      flash[:success] = "製作ステータスを更新しました"
      redirect_to request.referer
    end
  end


   private

  def order_item_params
    params.require(:order_item).permit(:making_status)
  end

end
