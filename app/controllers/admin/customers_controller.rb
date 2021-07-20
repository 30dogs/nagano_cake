class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  # before_action :ensure....は消しました

  def index
    #@customers = Customer.all
    @customers = Customer.page(params[:page]).reverse_order
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to admin_customer_path(@customer)
  end

   def customer_params
     	params.require(:customer).permit(:last_name, :first_name, :last_name_kana,
     	:first_name_kana, :email, :postcode, :address, :phone_number, :is_deleted)
   end

end
