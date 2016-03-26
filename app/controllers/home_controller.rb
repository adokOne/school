class HomeController < ApplicationController

  def index
    render layout: false
  end

  def refresh_fb_reviews

    Rails.cache.write("_school_reviews",fb_manager(params[:token]).get_school_posts,  expire: 12.month)
    Rails.cache.write("_club_reviews",fb_manager( params[:token] ).get_club_posts,  expire: 12.month)
    render text: "refreshed"
  end

  def school
    @courses   = ::Course.active.for_school.order(date_start: :asc)
    @teachers  = ::Teacher.for_school
    @photos    = ::Photo.for_school
    @lessons   = ::Lesson.for_school
    @top_menu  = I18n.t("school.school_top_links")
    @reviews   = Rails.cache.fetch("_school_reviews", expire: 12.month) do
      fb_manager( Settings.fb_token ).get_school_posts
    end
  end

  def club
    @links_type = "club"
    @courses   = ::Course.active.for_club
    @teachers  = ::Teacher.for_club
    @photos    = ::Photo.for_club
    @lessons   = ::Lesson.for_club
    @top_menu  = I18n.t("school.club_top_links")
    @reviews   = Rails.cache.fetch("_club_reviews", expire: 12.month) do
      fb_manager( Settings.fb_token ).get_club_posts
    end
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

  def call
    ApplicationMailer.call_mail(Settings.notification_mail, allowed_params[:name], allowed_params[:phone] ).deliver_later
    render json: {success: true}
  end

  def error404
    render status: :not_found,layout: false
  end

  def subscribe
    params_to_create = allowed_params.dup
    params_to_create[:date] = params_to_create[:date].to_s.split(",").first
    item = Subscriber.check!(params_to_create)
    if item.valid?
      type = item.school_subscribe ?  "school_registration" : "club_registration"
      ApplicationMailer.send_mail(Settings.email_templates[type], item.email, {:EMAIL => item.email, :USERNAME=> item.name, :PHONE => item.phone, :GROUP_NAME => item.course.try(:name), :GROUP_DATE => item.date }  ).deliver_later
      ApplicationMailer.send_mail(Settings.email_templates["#{type}_admin"], Settings.notification_mail, {:EMAIL => item.email, :USERNAME=> item.name, :PHONE => item.phone, :GROUP_NAME => item.course.try(:name), :GROUP_DATE => item.date }  ).deliver_later
      json = { success: true }
    else
      json = { success: false, errors: item.errors }
    end
    render json: json
  end

  def add_cv
    item = Cv.new(cv_allowed_params)
    if item.valid?
      [item.email, Settings.notification_mail].each do |mail|
        ApplicationMailer.send_mail(Settings.email_templates['add_cv'], mail, {:EMAIL => item.email, :USERNAME=> item.name, :PHONE => item.phone }  ).deliver_later
      end
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

  def fb_manager( token )
    @fb ||= Fb.new(token)
  end

end
