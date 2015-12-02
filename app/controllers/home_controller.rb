class HomeController < ApplicationController

  def main
    @pages = Page.published.by_rating.paginate(page: params[:page], per_page: 5)
    @categories = Category.get_parent
  end

  def contacts
    @form = Feedback.new
  end

  def products
    @products_for_top = Product.active.for_top
    @products = Product.active.for_table
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
