class Admin::OrderItemsController < ApplicationController
  def update
    @order = Order.find(params[:order_id])
    @order_item = OrderItem.find(params[:id])
    if @order_item.update(making_status: params[:order_item][:making_status].to_i)
      
      # [目的]making_statusが2のレコードが存在する場合、ordersテーブルのカラムstatusを2にする。
      # making_statusが2のレコードが存在する場合にtrue
      # making_statusが2のレコードが存在しない場合にfalse
      if @order.order_items.find_by(making_status: 2)
        @order.update(status: 2)
      end
      # 10~12行目の別パターン↓
      # nil?はオブジェクトが存在しない場合にtrueが返される。
      # nil?でmaking_statusが2のレコードが存在しない場合にtrueが返される。
      # nil?でmaking_statusが2のレコードが存在する場合にfalseが返される。
      # unless @order.order_items.find_by(making_status: 2).nil?
      # @order.update(status: 2)
      # end
     
      # [目的] すべてのレコードmaking_statusが3の場合にstatusを3にする
      # [nil?でmaking_statusが0のレコードが存在しない場合trueが返される]
      # [nil?でmaking_statusが1のレコードが存在しない場合trueが返される]
      # [nil?でmaking_statusが2のレコードが存在しない場合trueが返される]
      # すべての条件がtrueの場合に処理を実行したい => && を使う
      if @order.order_items.find_by(making_status: 0).nil? && @order.order_items.find_by(making_status: 1).nil? && @order.order_items.find_by(making_status: 2).nil?
        @order.update(status: 3)
      end
      flash[:success] = "製作ステータスを更新しました"
      redirect_to admin_order_path(@order.id)
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:making_status)
  end

end
