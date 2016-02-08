class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :set_breadcrumbs
  before_action :set_default_meta
  #protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?
  helper_method :liqpay_form
  before_filter :set_current_locale

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
  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def liqpay_form(liqpay_request, options={}, &block)
    id = options.fetch(:id, 'liqpay_form')
    title = options.fetch(:title, 'Pay with LiqPAY')
    content_tag(:form, :id => id, :action => Liqpay::LIQPAY_ENDPOINT_URL, :method => :post) do
      liqpay_request.form_fields.each do |name, value|
        concat hidden_field_tag(name, value)
      end
      if block_given?
        yield
      else
        concat submit_tag(title, :name => nil)
      end
    end
  end


  private
  def set_current_locale
    I18n.locale = params[:locale]
  end
end
