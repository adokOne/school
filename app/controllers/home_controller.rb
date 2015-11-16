class HomeController < ApplicationController

  def index
    render layout: false
  end

  def school
    @courses   = ::Course.active.for_school.order(date_start: :asc)
    @teachers  = ::Teacher.for_school
    @photos    = ::Photo.for_school
    @lessons   = ::Lesson.for_school
  end

  def club
    @links_type = "club"
    @courses   = ::Course.active.for_club
    @teachers  = ::Teacher.for_club
    @photos    = ::Photo.for_club
    @lessons   = ::Lesson.for_club
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
    item = Subscriber.check!(allowed_params)
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
    params.require(:subscriber).permit(:name,:email,:school_subscribe,:club_subscribe,:course_id,:phone)
  end

  def cv_allowed_params
    params.require(:cv).permit(:name,:email,:phone)
  end

end
