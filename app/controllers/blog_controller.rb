class BlogController < ApplicationController

  def index
    @items = Page.published.by_rating.page(params[:page])
  end

  def item
    @item = Page.find_by_seo(params[:seo_name].split("/"))
  end

  def search
    @similar = Page.limit(3).order(id: :desc)
    @items = []
    @count = 0
    Page.where("`title` LIKE :search AND category_id IS NOT NULL OR `anons` LIKE :search AND category_id IS NOT NULL OR `desc` LIKE :search AND category_id IS NOT NULL",{search: "%#{params[:search]}%"}).includes(:category).all.map do |page|
      @items[page.category_id] = {category: page.category, pages:[]} if @items[page.category_id].nil?
      @items[page.category_id][:pages] << page
      @count +=1
    end
    @items.compact!
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

end
