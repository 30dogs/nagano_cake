class Public::CustomersController < ApplicationController

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
  end

end
