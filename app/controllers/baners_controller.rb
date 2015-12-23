class BanersController < ApplicationController

  before_filter :require_login

  before_action :set_data, only: [:edit,:new]

  #before_filter :is_own?, only: [:show,:update,:edit]

  def create
    if cookies[:new_page].present?
      flash[:error] = I18n.t("uex.cant_create_to_many_pages")
      redirect_to(request.referer + "#notice") and return
    end
    baner =  current_user.pages.new(allowed_params)
    if baner.valid?
      baner.save
      cookies[:new_page] = { value: true, expires:  1.hour.from_now  }
      redirect_to user_path(current_user)
    else
      flash[:page] = baner
      flash[:error] = [t("uex.form.#{baner.errors.messages.keys.first}"), baner.errors.messages[baner.errors.messages.keys.first].first].join(" ")
      flash[:message] = I18n.t("uex.page_on_moder")
      redirect_to edit_user_baner_path(current_user, baner)
    end
  end




  def update
    baner = current_user.pages.find(params[:id])
    baner.update_attributes(allowed_params)
    if baner.valid?
      baner.save
      baner.disactivate!
      flash[:message] = I18n.t("uex.page_on_moder")
      redirect_to edit_user_baner_path(current_user, baner)
    else
      flash[:page] = baner
      flash[:error] = [t("uex.form.#{baner.errors.messages.keys.first}"), baner.errors.messages[baner.errors.messages.keys.first].first].join(" ")
      redirect_to edit_user_baner_path(current_user,baner)
    end

  end

  def new
    @item = Page.new(flash[:page].present? ? flash[:page] : {})
    @has_editor = true
  end

  def edit
    @item = Page.find(params[:id])
    @has_editor = true
  end


  private

  def set_data
    @countries = Country.where(id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @cities    = City.where(country_id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @categories = Category.get_parent
  end

  def is_own?
    unless current_user.id == params[:id].to_i
      redirect_to root_path
    end
  end

  def allowed_params
    params.require(:page).permit(:title,:anons,:desc,:logo, :city_id, :country_id, :category_id)
  end

end
