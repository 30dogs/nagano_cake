class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @orders = Order.page(params[:page]).reverse_order
  end

  def show
    @order = Order.find(params[:id])

    # [目的] f.selectで用いる選択肢を作る。
    #配列をつくるために、Arrayクラスのインスタンスを生成する
    @array_order_status = Array.new
    # 配列の要素を追加する
    @array_order_status.push(["入金待ち", 0], ["入金確認中", 1], ["製作中",2], ["発送準備中", 3],["発送済み", 4])

    # [目的] f.selectで用いる選択肢を作る。
    #配列をつくるために、Arrayクラスのインスタンスを生成する
    @array_order_item_making_status = Array.new
    # 配列の要素を追加する
    @array_order_item_making_status.push(["着手不可", 0], ["製作待ち", 1], ["製作中", 2], ["製作完了", 3])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(status: params[:order][:status].to_i)
      # [目的]statusが1の場合、すべてのレコードのmaking_statusを1にする。
      if Order.statuses[@order.status] == 1
        @order.order_items.each do |order_item|
          order_item.update(making_status: 1)
        end
      end
      flash[:success] = "注文ステータスを更新しました"
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

