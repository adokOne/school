class HomeController < ApplicationController

  PER_PAGE= 10
  def main
    @has_search = true
    @cities    = City.where(country_id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @categories = Category.get_parent
    @pages = Page.published.by_rating.by_text(params[:search]).includes(:reviews).paginate(page: params[:page], per_page: PER_PAGE)
  end

  def contacts
    @form = Feedback.new( flash[:feedback].present? ? flash[:feedback] : {})
  end

  def products
    @body_cls = "products"
    @has_video = true
    @order = AnonimOrder.new( flash[:order].present? ? flash[:order] : {})
    #@products_for_top = Product.active.for_top
    @products = Product.active.for_table
    render template: "home/products_2"
  end

  def logout
    if current_user
      current_user.signout(cookies[User::COOKIE_NAME], request.remote_ip, request.user_agent)
      cookies.delete(User::COOKIE_NAME)
    end
    redirect_to root_url
  end

  def feedback
    if cookies[:new_feedback].present?
      flash[:error] = I18n.t("uex.cant_create_to_many_feedbacks")
    else
      feedback = Feedback.new(feedback_params)
      if feedback.valid?
        feedback.save
        cookies[:new_feedback] = { value: true, expires:  1.hour.from_now  }
        flash[:message] = I18n.t("uex.order_was_created")
      else
        flash[:error] = [t("uex.form.#{feedback.errors.messages.keys.first}"), feedback.errors.messages[feedback.errors.messages.keys.first].first].join(" ")
        flash[:feedback] = feedback
      end
    end
    redirect_to(request.referer + "#notice")
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
    @og_type = "object"
  end

  def item
    @item = Page.find(params[:id])
    @item.impressions.create(ip_address: request.remote_ip,user_id: current_user ? current_user.id : 0)
    @breadcrumbs_items = @item.prepare_breadcrumbs
    @breadcrumbs_last = @item.title


    @meta_desc  = @item.meta_is_generated ? @item.title  : @item.meta_desc
    @meta_title = @item.meta_is_generated ? @item.title  : @item.meta_title
    @meta_keys  = @item.meta_is_generated ? @meta_keys  : @item.meta_keys

    @section_name = "#{@item.category.title} #{@item.city.name}"
    @image = @item.logo
    @published_at = @item.created_at
    @og_type = "article"
  end

  def cities
    @cities    = City.where(country_id: Country::UKRAINE_ID )
  end


  def city
    @has_search = true
    @cities    = City.where(country_id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @allowed_categories = Category.get_parent
    @city  = City.find_by_seo_name(params[:seo_name])
    @pages = Page.published.by_rating.by_city(@city.id).paginate(page: params[:page], per_page: PER_PAGE)
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
    if logged_in?
      redirect_to edit_user_path(current_user, anchor: "orders")
    end
    @item = Product.find(params[:id])
  end

  def order
    if cookies[:new_order].present?
      flash[:error] = I18n.t("uex.cant_create_to_many_orders")
    else
      order = AnonimOrder.new(params[:anonim_order])
      if order.valid?
        if order.user_exist?
          flash[:error] = I18n.t("uex.user_exist_on_order", login_path: signin_users_path, forgot_path: forgot_users_path)
        else
          user = User.create(email: order.email, name: order.name, password: User.password)
          token = user.signin( request.remote_ip, request.referer, request.user_agent)
          cookies[User::COOKIE_NAME] = { value: token, expires: false ? 4.hour.from_now : 2.week.from_now }
          order.create_real
          cookies[:new_order] = { value: true, expires:  1.hour.from_now  }
          flash[:message] = I18n.t("uex.order_was_created")
        end
      else
        flash[:order] = order
        flash[:error] = [t("uex.form.#{order.errors.messages.keys.first}"), order.errors.messages[order.errors.messages.keys.first].first].join(" ")
      end
    end
    redirect_to request.referer + "#order"
  end

  def add
    if logged_in?
      redirect_to new_user_baner_path(current_user)
    end
    @has_editor = true
    @countries = Country.where(id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @cities    = City.where(country_id: Country::UKRAINE_ID ).pluck("name_#{I18n.locale}",:id)
    @categories = Category.get_parent
    @item = AnonimPage.new(flash[:page].present? ? flash[:page] : {})
  end

  def add_baner
    if cookies[:new_page].present?
      flash[:error] = I18n.t("uex.cant_create_to_many_pages")
      redirect_to(request.referer + "#notice") and return
    end
    baner = AnonimPage.new(baner_params)
    if baner.valid?
      if baner.user_exist?
        flash[:page] = baner
        flash[:error] = I18n.t("uex.user_exist_on_order", login_path: signin_users_path, forgot_path: forgot_users_path)
        redirect_to(request.referer + "#notice") and return
      else
        user = User.create(email: baner.email, name: baner.name, password: User.password)
        token = user.signin( request.remote_ip, request.referer, request.user_agent)
        cookies[User::COOKIE_NAME] = { value: token, expires: false ? 4.hour.from_now : 2.week.from_now }
        baner = baner.create_real(baner_params[:logo])
        flash[:message] = I18n.t("uex.page_on_moder")
        cookies[:new_page] = { value: true, expires:  1.hour.from_now  }
        redirect_to edit_user_baner_path(current_user, baner) and return
      end
    else
      flash[:page] = baner
      flash[:error] = [t("uex.form.#{baner.errors.messages.keys.first}"), baner.errors.messages[baner.errors.messages.keys.first].first].join(" ")
      redirect_to(request.referer + "#notice") and return
    end
  end

  def baner_params
    params.require(:anonim_page).permit(:name,:email,:phone,:title,:anons,:logo,:category_id,:city_id, :country_id, :desc)
  end

  def feedback_params
    params.require(:feedback).permit(:name,:email,:phone,:message)
  end



end
