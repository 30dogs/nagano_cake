# frozen_string_literal: true

class Public::Customers::SessionsController < Devise::SessionsController

  before_action :reject_customer, only: [:create]

  # [目的] 会員のログインページに遷移するcustomers#newアクションが実行される前に、管理者のログインが行われていれば、管理者をログアウトさせる。
  # [方法] before_actionを使って、newアクションが実行される前に、管理者がログインしていれば管理者をログアウトさせるアクションを実行させる。
  before_action :sign_out_admin, only: [:new]

  def sign_out_admin
    if admin_signed_in?
      # [目的] current_adminログアウトさせる
      # sign_out_and_redirect(resource_or_scope) => Object
      # [解説] Sign out a user and tries to redirect to the url specified by after_sign_out_path_for.
      sign_out_and_redirect(current_admin)
    end
  end
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
    # downcase
    # [解説] Stringクラスのインスタンスメソッド。全ての大文字を対応する小文字に置き換えた文字列を返します。
    @customer = Customer.find_by(email: params[:customer][:email].downcase)
    if @customer
      # valid_password?(password) => Boolean
      # [解説] Verifies whether a password (ie from sign in) is the user password.
      # [解説] Returns:(Boolean)

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
