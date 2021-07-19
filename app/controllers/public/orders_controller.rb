class Public::OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @customer = current_customer
    deliveries = current_customer.deliveries
    @array_deliveries = Array.new
    deliveries.each do |delivery|
      postcode = delivery.postcode
      address = delivery.address
      name = delivery.name
      delivery_info = "#{postcode} #{address} #{name}"
      array_delivery = Array.new
      array_delivery.push(delivery_info, delivery.id)
      @array_deliveries.push(array_delivery)
    end
  end

  def finish
  end

  def create
  end

  def confirm
  end

end
