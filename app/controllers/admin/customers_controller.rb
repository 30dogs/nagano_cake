class Admin::CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @customers = Customer.all
    #@customers = Customer.page(params[:page]).reverse_order
  end

  def show
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to admin_customer_path(@customer)
  end

  # def customer_params
  #   	params.require(:customer).permit(:last_name, :first_name, :last_name_kana,
  #   	:first_name_kana, :email, :postcode, :address, :phone_number, :is_deleted)
  # end

end
