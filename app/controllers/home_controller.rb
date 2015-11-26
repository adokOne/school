class HomeController < ApplicationController

  def main
    @pages = Page.published.by_rating.page(params[:page])
    @categories = Category.get_parent
  end

  def contacts
    @form = Cv.new
  end

  def products
    @products = Course.limit(3).all
  end

  def category
    @item  = Category.find_by_seo(params[:seo_name].split("/"))
    @pages = Page.published.by_rating.by_category(@item.id).page(params[:page])
    @categories = Category.get_parent
    @breadcrumbs_items = @item.prepare_breadcrumbs( true )
    @breadcrumbs_last = @item.title
  end

  def item
    @item = Page.find(params[:id])
    @breadcrumbs_items = @item.prepare_breadcrumbs
    @breadcrumbs_last = @item.title
  end


end
