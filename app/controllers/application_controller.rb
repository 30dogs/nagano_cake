class ApplicationController < ActionController::Base
  # before_action :authenticate_user!, except: [:top, :about]

  protected
  def after_sign_in_path_for(resource)
    #ログインした時のリンク先
  end

  def after_sign_up_path_for(resource)
    #新規登録した時のリンク先
  end

  def after_sign_out_path_for(resource)
    #ログアウトした時のリンク先
  end
end


  # def after_sign_in_path_for(resource)
  #   case resource
  #   when User
  #     user_posts_path
  #   when AdminUser
  #     admin_user_posts_path
  #   end
  # end
