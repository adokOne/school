class BlogController < ApplicationController

  before_action :set_manifest

  def index
    @similar = Page.limit(3).order(id: :desc)
    @items   = Category.where(parent_id:0).all
  end

  def category
    @item    = Category.find_by_seo(params[:seo_name].split("/"))
    @similar = Page.limit(3).where("category_id != ?",@item.id).order(id: :desc)
    if @item.parent.present?
      only_photos = @item.parent.only_photos
    else
      only_photos = @item.only_photos
    end
    render only_photos ? "photo_category" : "category"
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

  private

  def set_manifest
    @js_manifest = "blog"
  end


end
