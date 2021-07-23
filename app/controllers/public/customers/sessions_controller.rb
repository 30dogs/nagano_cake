# frozen_string_literal: true

class Public::Customers::SessionsController < Devise::SessionsController
  before_action :reject_customer, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
  # ・if (@customer.valid_password?(params[:customer][:password])で、入力されたパスワードが正しいことを確認しています。
  # ・(@customer.active_for_authentication? == false))で、@customerのactive_for_authentication?メソッドがfalseであるかどうかを確認しています。
  # ・上記の2点が当てはまれば、ログインページにリダイレクトし、エラーメッセージを表示するようにしています。
  def reject_customer
    @customer = Customer.find_by(email: params[:customer][:email].downcase)
    if @customer
      if (@customer.valid_password?(params[:customer][:password]) && (@customer.active_for_authentication? == false))
        flash[:error] = "退会済みです。"
        redirect_to new_customer_session_path
      end
    else
      flash[:error] = "必須項目を入力してください。"
    end
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
