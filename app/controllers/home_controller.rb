class HomeController < ApplicationController

  def main
    @has_search = true
    @cities    = City.where(country_id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @categories = Category.get_parent
    @pages = Page.published.by_rating.by_text(params[:search]).paginate(page: params[:page], per_page: 5)
  end

  def contacts
    @form = Feedback.new
  end

  def products
    @products_for_top = Product.active.for_top
    @products = Product.active.for_table
  end

  def category
    @has_search = true
    seo_name = params[:seo_name]
    splited = seo_name.split("-")
    @city = false
    if splited.size > 1
      if @city = City.find_by_seo_name(splited.last)
        seo_name = seo_name.sub("-#{splited.last}","")
      end
    end
    @item  = Category.find_by_seo(seo_name.split("/"))
    if @city
      @pages = Page.published.by_rating.by_category(@item.id).by_city(@city.id).page(params[:page])
    else
      @pages = Page.published.by_rating.by_category(@item.id).page(params[:page])
    end

    @categories = Category.get_parent
    @cities    = City.where(country_id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @breadcrumbs_items = @item.prepare_breadcrumbs( true )
    @breadcrumbs_last = @city ? "#{@item.title} #{@city.name}" : @item.title



    @meta_desc  = @item.meta_is_generated ? I18n.t("uex.default_category_desc", {name: @breadcrumbs_last } )   : @item.meta_desc
    @meta_title = @item.meta_is_generated ? I18n.t("uex.default_category_title", {name: @breadcrumbs_last } )  : @item.meta_title
    @meta_keys  = @item.meta_is_generated ? @meta_keys  : @item.meta_keys

  end

  def item
    @item = Page.find(params[:id])
    @item.impressions.create(ip_address: request.remote_ip,user_id: current_user ? current_user.id : 0)
    @breadcrumbs_items = @item.prepare_breadcrumbs
    @breadcrumbs_last = @item.title


    @meta_desc  = @item.meta_is_generated ? @item.title  : @item.meta_desc
    @meta_title = @item.meta_is_generated ? @item.title  : @item.meta_title
    @meta_keys  = @item.meta_is_generated ? @meta_keys  : @item.meta_keys


  end

  def cities
    @cities    = City.where(country_id: Country::UKRAINE_ID )
  end


  def city
    @has_search = true
    @cities    = City.where(country_id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @allowed_categories = Category.get_parent
    @city  = City.find_by_seo_name(params[:seo_name])
    @pages = Page.published.by_rating.by_city(@city.id).paginate(page: params[:page], per_page: 5)
    @categories = Category.get_parent


    @meta_desc  = @city.meta_is_generated ? I18n.t("uex.default_city_desc", {name: @city.name } )   : @city.meta_desc
    @meta_title = @city.meta_is_generated ? I18n.t("uex.default_city_title", {name: @city.name } )  : @city.meta_title
    @meta_keys  = @city.meta_is_generated ? @meta_keys  : @city.meta_keys
  end

  def search
    search = Search.new(params[:search])
    if search.valid?
      json = {success: true, url: search.build_url}
    else
      json = {success: false}
    end
    render json: json
  end

  def review
    review = Review.create(params[:reviews])
    flash[:message] = I18n.t("uex.review_moderate")
    redirect_to request.referer + "#comments"

  end

  def product

  end

end
