require 'will_paginate'
module PaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected
    def page_number(page)
      unless page == current_page
        link(:a, page, page, class: "page-numbers")
      else
        link(:span, page, "#", class: 'page-numbers current')
      end
    end

      def previous_page
        num = @collection.current_page > 1 && @collection.current_page - 1
        previous_or_next_page(num, "", 'prev page-numbers')
      end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page( num, "", 'next page-numbers')
    end

    def previous_or_next_page(page, text, classname)
      if page
        link(:a, text, page, :class => classname)
      else
        link(:a, text, "#", :class => classname + ' disabled')
      end
    end

    def html_container(html)
      tag(:div, html, container_attributes)
    end

    private

    def link(element, text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = rel_value(target)
        target = url(target)
      end

      unless target == "#"
          attributes[:href] = target
      end

      classname = attributes[:class]
      attributes.delete(:classname)
      tag(element, text, attributes)
    end
  end
end
