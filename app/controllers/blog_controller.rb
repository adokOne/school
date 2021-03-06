class BlogController < ApplicationController

  before_action :set_manifest

  def index
    @similar = Page.active.limit(3).order(id: :desc)
    @items   = Category.where(parent_id:0).all
    top_menu
  end

  def category
    top_menu(true)
    @item    = Category.find_by_seo(params[:seo_name].split("/"))
    @similar = Page.active.limit(3).where("category_id != ?",@item.id).order(id: :desc)
    if @item.parent.present?
      only_photos = @item.parent.only_photos
    else
      only_photos = @item.only_photos
    end
    render only_photos ? "photo_category" : "category"
  end

  def item
    top_menu(true)
    @item = Page.active.find_by_seo(params[:seo_name].split("/"))
    @similar = Page.active.limit(3).where("category_id != ?",@item.category_id).order(id: :desc)
  end

  def search
    top_menu(true)
    @similar = Page.limit(3).order(id: :desc)
    @items = []
    @count = 0
    Page.active.where("`title` LIKE :search AND category_id IS NOT NULL OR `anons` LIKE :search AND category_id IS NOT NULL OR `desc` LIKE :search AND category_id IS NOT NULL",{search: "%#{params[:search]}%"}).includes(:category).all.map do |page|
      @items[page.category_id] = {category: page.category, pages:[]} if @items[page.category_id].nil?
      @items[page.category_id][:pages] << page
      @count +=1
    end
    @items.compact!
  end

  def subscribe
    item = Subscriber.check!(allowed_params)
    if item.valid?
      [item.email, Settings.notification_mail].each do |mail|
        ApplicationMailer.send_mail(Settings.email_templates['blog_subscribe'], mail , {:EMAIL => item.email, :USERNAME=> item.name, :PHONE => item.phone }  ).deliver_later
      end
      json = { success: true }
    else
      json = { success: false, errors: item.errors }
    end
    render json: json
  end

  private

  def set_manifest
    @js_manifest = "blog"
  end

  def allowed_params
    params.require(:subscriber).permit(:name,:email,:blog_subscribe)

  end

  def top_menu( is_href = false )
    @top_menu = Category.where(parent_id:0).all.inject({}){|hash, item| hash[item.seo_name] = {text: item.title}; hash }
    @is_href = is_href
  end


end
