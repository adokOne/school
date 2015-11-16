class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :set_link_type_ands_subscriber
  protect_from_forgery with: :exception

  helper_method :addresses, :vacancies

  def addresses
    Address.active.where(is_main: true).all
  end

  def vacancies
    Vacancy.where(active: true).all
  end

  def set_link_type_ands_subscriber
    @links_type = "school"
    @subscriber = Subscriber.new
    @cv = Cv.new
    @lessons = []
    @top_menu = {}
  end
end
