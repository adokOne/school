module ApplicationHelper
  def url path
    path = path.to_s
    lang_url = I18n.default_locale == I18n.locale ? [""] : ["",I18n.locale]

    path = (lang_url + path.split("/").reject(&:empty?)).reject(&:empty?).join("/")

    url = path.empty? ? "/" : "/#{path}"
    Settings.domain + url
  end

  def url_is_current?( url, cls = "active", action = false )
    if action
      /#{params[:controller]}/ =~ url && /#{params[:action]}/ =~ action ? cls : ""
    else
      /#{params[:action]}/ =~ url || /#{params[:controller]}/ =~ url ? cls : ""
    end
  end

  def breadcrumbs items = [], last_text= ""
    render partial: "shared/breadcrumbs", locals: {items: items, last_text: last_text}
  end

  def page_name( page_id )
    Page.find_by_id(page_id).try(:title)
  end

end
