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

  end

  def quit
  end

end
