class BanersController < ApplicationController

  before_filter :require_login

  before_action :set_data, only: [:edit,:new]

  #before_filter :is_own?, only: [:show,:update,:edit]

  def create
    baner =  current_user.pages.new(allowed_params)
    if baner.valid?
      redirect_to user_path(current_user)
    else
      flash[:errors] = baner.errors.messages
      redirect_to new_user_baner_path
    end
  end

  def update
    baner = current_user.pages.find(params[:id])
    baner.update_attributes(allowed_params)
    if baner.valid?
      redirect_to user_path(current_user)
    else
      flash[:errors] = baner.errors.messages
      redirect_to edit_user_baner_path(current_user,baner)
    end

  end

  def new
    @item = Page.new
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
