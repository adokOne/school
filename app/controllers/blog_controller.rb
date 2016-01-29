class BlogController < ApplicationController

  def index
    @items = BlogPage.published.by_rating.paginate(page: params[:page], per_page: 5)
  end

  def item

    if page = BlogPage.find_by_slug(params[:seo_name])
      redirect_to( page.link, status: 301 ) and return
    end


    @item = BlogPage.find_by_seo_name!(params[:seo_name])
    @breadcrumbs_items = {"blog": I18n.t("uex.blog")}
    @breadcrumbs_last = @item.title
    @meta_desc  = @item.meta_is_generated ? @item.anons.truncate(170) : @item.meta_desc
    @meta_title = @item.meta_is_generated ? @item.title : @item.meta_title
    @meta_keys  = @item.meta_is_generated ? @item.anons.truncate(50)  : @item.meta_keys
    @image = @item.logo
  end


  def previev_blog
    @item = BlogPage.new(preview_params)
    #set_baner_params( true )
    render :item
  end

  def search
    @similar = BlogPage.limit(3).order(id: :desc)
    @items = []
    @count = 0
    BlogPage.where("`title` LIKE :search AND category_id IS NOT NULL OR `anons` LIKE :search AND category_id IS NOT NULL OR `desc` LIKE :search AND category_id IS NOT NULL",{search: "%#{params[:search]}%"}).includes(:category).all.map do |page|
      @items[page.category_id] = {category: page.category, pages:[]} if @items[page.category_id].nil?
      @items[page.category_id][:pages] << page
      @count +=1
    end
    @items.compact!
  end

  def subscribe
    item = Subscriber.create(allowed_params)
    if item.valid?
      json = { success: true }
    else
      json = { success: false, errors: item.errors }
    end
    render json: json
  end
  def preview_params
    params.permit(:name,:email,:phone,:title,:anons,:logo,:category_id,:city_id, :country_id, :desc, :site, :meta_title, :meta_desc, :meta_keys)
  end
end
