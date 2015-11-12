class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :set_link_type
  protect_from_forgery with: :exception

  helper_method :addresses, :vacancies

  def addresses
    Address.active.where(is_main: true).all
  end

  def vacancies
    Vacancy.all
  end

  def set_link_type
    @links_type = "school"
  end
end
