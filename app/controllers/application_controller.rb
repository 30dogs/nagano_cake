class ApplicationController < ActionController::Base
  #before_action :authenticate_user!, except: [:top, :about]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # protected
  # def after_sign_in_path_for(resource)
  #   #ログインした時のリンク先
  # end

  # def
  #   #新規登録した時のリンク先
  # end

  # def after_sign_out_path_for(resource)
  #   #ログアウトした時のリンク先
  # end

  # def after_sign_in_path_for(resource)
  #   case resource
  #   when User
  #     user_posts_path
  #   when AdminUser
  #     admin_user_posts_path
  #   end
  # end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :last_name, :first_name, :last_name_kana, :first_name_kana, :postcode, :address, :phone_number, :email])
  end
end
