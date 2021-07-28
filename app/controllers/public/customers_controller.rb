class Public::CustomersController < ApplicationController

  def edit
    @customer = Customer.find(current_customer.id)
  end

  def quit_check
  end

  def update
  end

  def quit
  end

end
