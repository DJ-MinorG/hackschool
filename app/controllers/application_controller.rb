class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def require_is_admin
    unless current_user.admin?
      flash[:alert] = "You are not admin"
      redirect_to root_path
    end
  end

  def check_subscription_expiration
    if !current_user.member_expire_date || current_user.member_expire_date < Time.now

      flash[:notice] = "您还未订阅，请先选择您的套餐"
      redirect_to plans_path

    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
