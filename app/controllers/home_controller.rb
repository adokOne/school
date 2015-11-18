class HomeController < ApplicationController

  def index
    render layout: false
  end

  def school
    @courses   = ::Course.active.for_school.order(date_start: :asc)
    @teachers  = ::Teacher.for_school
    @photos    = ::Photo.for_school
    @lessons   = ::Lesson.for_school
    @top_menu  = I18n.t("school.school_top_links")
  end

  def club
    @links_type = "club"
    @courses   = ::Course.active.for_club
    @teachers  = ::Teacher.for_club
    @photos    = ::Photo.for_club
    @lessons   = ::Lesson.for_club
    @top_menu  = I18n.t("school.club_top_links")
    @reviews   = Rails.cache.fetch("reviews", expire: 12.hours) do
      fb_manager.get_club_posts
    end
     @reviews = []
  end

  def show_vacancy
    @vacancy = Vacancy.find_by_id(params[:id])
    if @vacancy
      json = {success: true, html: render_to_string("shared/_vacancy_desc",layout: false) }
    else
      json = {success: false}
    end
    render json: json
  end

  def partners
    @partners = Partner.active
  end

  def contacts
    @addresses = Address.active.order(is_main: :desc)
  end

  def error404
    render status: :not_found,layout: false
  end

  def subscribe
    params_to_create = allowed_params.dup
    params_to_create[:date] = params_to_create[:date].split(",").first
    item = Subscriber.check!(params_to_create)
    if item.valid?
      json = { success: true }
    else
      json = { success: false, errors: item.errors }
    end
    render json: json
  end

  def add_cv
    item = Cv.new(cv_allowed_params)
    if item.valid?
      item.save
      json = { success: true }
    else
      json = { success: false, errors: item.errors }
    end
    render json: json
  end

  private

  def allowed_params
    params.require(:subscriber).permit(:name,:email,:school_subscribe,:club_subscribe,:course_id,:phone,:blog_subscribe,:level,:date)
  end

  def cv_allowed_params
    params.require(:cv).permit(:name,:email,:phone,:document)
  end

  def fb_manager
    @fb ||= Fb.new
  end

end
