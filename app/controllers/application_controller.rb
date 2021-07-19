class ApplicationController < ActionController::Base
  # "user"というモデルがないため3行目をコメントアウト
  # before_action :authenticate_user!, except: [:top, :about]

  protected
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_orders_path
    when Customer
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    #新規登録した時のリンク先
  end

  # くまさん_この記述があるとログアウトできないためコメントアウト
  # def after_sign_out_path_for(resource)
  # end
end


  # def after_sign_in_path_for(resource)
  #   case resource
  #   when User
  #     user_posts_path
  #   when AdminUser
  #     admin_user_posts_path
  #   end
  # end
