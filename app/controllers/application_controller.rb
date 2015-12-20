class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :set_breadcrumbs
  before_action :set_default_meta
  #protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?

  def set_breadcrumbs
    @breadcrumbs_items = {}
    @breadcrumbs_last = ""
  end

  def set_default_meta
    @meta_keys  = t("uex.default_keys")
    @meta_desc  = t("uex.default_desc")
    @meta_title = t("uex.default_title")
  end


  protected

  def current_user
    @current_user ||= User.authenticate_with_token(cookies[User::COOKIE_NAME], request.remote_ip, request.user_agent) if cookies[User::COOKIE_NAME]
  end

  def logged_in?
    current_user.present?
  end

  # you should change this to whatever logic you need
  def require_login
    unless current_user
      session[:return_to] ||= request.referer
      if request.xhr?
        render json: {success: false, login: false}
      else
        redirect_to signin_users_path
      end
    end
  end

end
