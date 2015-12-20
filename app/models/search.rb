class Search
  include ::ActiveAttr::Model
  attribute :city_id,  type: Integer
  attribute :category_id,  type: Integer
  attribute :text,  type: String


  def valid?
    p self
    valid = self.category_id.present? && !self.category_id.zero?   || self.city_id.present? && !self.city_id.zero? || self.text.present?
    if self.text.present?
      valid = false if self.text.length > 50
    end
    valid
  end

  def build_url
    url = false
    if self.category_id.present? && !self.category_id.zero? && self.city_id.present? && !self.city_id.zero?
      url = [category.link, city.seo_name].join("-")
    elsif self.city_id.present? && !self.city_id.zero?
      url = city.link
    elsif self.category_id.present? && !self.category_id.zero?
      url = category.link
    end
    if self.text.present?
      if url
        url = "#{url}?search=#{self.text}"
      else
        url = "/?search=#{self.text}"
      end

    end
    url
  end

  def city
    City.find(self.city_id)
  end

  def category
    Category.find(self.category_id)
  end

end
