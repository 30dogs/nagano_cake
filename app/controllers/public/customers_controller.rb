class Public::CustomersController < ApplicationController

  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def quit_check
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to mypage_path
    else
        render :edit
    end
  end

  def quit
    customer = Customer(current_customer.id)
    customer.is_deleted = false
    customer.update
    redirect_to root_path
  end

end
