class ClickController < ApplicationController

  layout "click"

  def index
    @title = t("click.index_title")
  end

  def portfolio
    @title = t("click.portfolio_title")
    @items = Portfolio.all
  end

  def prices
    @body_cls = "price-page"
    @title = t("click.prices_title")
    @items = ClickPrice.active.all
  end

  def about
    @body_cls = "about-page"
    @title = t("click.about_title")
  end

  def kontekst

  end

  def marketing

  end

  def create_site

  end

  def seo

  end

end
