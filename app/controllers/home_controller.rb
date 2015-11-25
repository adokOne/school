class HomeController < ApplicationController

  def index
    @pages = Page.published.by_rating.page(params[:page])
  end


end
