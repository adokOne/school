module ApplicationHelper
  def url path
    path = path.to_s
    lang_url = I18n.default_locale == I18n.locale ? [""] : ["",I18n.locale]

    path = (lang_url + path.split("/").reject(&:empty?)).reject(&:empty?).join("/")

    url = path.empty? ? "/" : "/#{path}"
    Settings.domain + url
  end

  def url_is_current?( url, cls = "active" )
    /#{params[:action]}/ =~ url || /#{params[:controller]}/ =~ url ? "active" : ""
  end

  def fb_avatar( id )
    url = "https://graph.facebook.com/#{id}/picture?height=145&width=145"
  end

  def fb_date( date )
    Date.parse(date).strftime("%d.%m/%Y") rescue ""
  end

end
