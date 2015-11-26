class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :set_breadcrumbs
  protect_from_forgery with: :exception


  def set_breadcrumbs
    @breadcrumbs_items = {}
    @breadcrumbs_last = ""
  end

end
