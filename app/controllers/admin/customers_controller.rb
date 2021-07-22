class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

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
    if @customer.save
      flash[:notice] = "You have updted customer successfully."
      redirect_to admin_customer_path(@customer.id)
    else
      render :edit
    end
  end



# 　private

   def customer_params
     	params.require(:customer).permit(:last_name, :first_name, :last_name_kana,
     	:first_name_kana, :email, :postcode, :address, :phone_number, :is_deleted)
   end

end
