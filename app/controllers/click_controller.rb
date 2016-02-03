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
    @title = t("click.kontekst_title")
  end

  def marketing
    @title = t("click.marketing_title")
  end

  def create_site
    @title = t("click.create_site_title")
  end

  def seo
    @title = t("click.seo_title")
  end

end
