class HomeController < ApplicationController

  def index
    render layout: false
  end

  def school
    @courses   = ::Course.active.for_school
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

end
