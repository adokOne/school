class BlogController < ApplicationController

  def index
    @items = BlogPage.published.by_rating.paginate(page: params[:page], per_page: 5)
  end

  def item
    @item = BlogPage.find_by_seo_name!(params[:seo_name])
    @breadcrumbs_items = {"blog": I18n.t("uex.blog")}
    @breadcrumbs_last = @item.title
    @meta_desc  = @item.anons.truncate(170)
    @meta_title = @item.title
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

end
