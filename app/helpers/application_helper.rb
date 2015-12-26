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

  def locale_url( locale )
    return "#" if I18n.locale == locale
    url_for( locale: locale )
  end

  def render_categories(categories,active)
    render_list = Proc.new do | categories, active, is_sub |
      content_tag :ul, class: (is_sub ? "sub" : "sbOptions cats")  do
        categories.each_with_index.map do |cat, i|
          content_tag :li , class: ("last" if i == categories.size - 1 ) do
            str = [
              link_to(url(cat.link), class: [("active" if active == cat.id),"steps_lable"].compact) do
                [cat.title ,(cat.childrens.any? ?  content_tag(:span, "", class: "arrow-select" ) : "" )].join.html_safe
              end
            ]
            if cat.childrens.any?
              str << render_list.call(cat.childrens, active,true)
            end
            str.join("").html_safe
          end
        end.join("").html_safe
      end
    end
    content_tag :div, :class => 'sbHolder' do
      render_list.call(categories, active, false)
    end
  end

end
