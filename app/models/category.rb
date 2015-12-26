class Category < ActiveRecord::Base

  include Localizable
  #include Localizable
  BLOG_LIMIT = 4
  # #includes :parent
  before_validation :generate_seo
  #Relations
  has_many   :pages, dependent: :restrict_with_exception
  has_many   :childrens, class_name:Category, foreign_key: :parent_id, dependent: :restrict_with_exception
  belongs_to :parent, class_name: Category, foreign_key: :parent_id


  has_attached_file :logo,
                    styles: { home: "64x64#",medium: "100x100#", big: "325x325#" },
                    default_url: "/img/page-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.:extension",
                    url:         "/system/:class/:id/:style.:extension"

  validates_attachment_content_type :logo, :content_type => /\Aimage/

  after_save :clear_cache

  def to_tree_item
    {
      id:        self.id,
      title:     self.title,
      parent_id: self.parent_id,
      childrens: self.all_childrens.map(&:to_tree_item),
      seo:       self.seos.join("/")
    }
  end

  def generate_seo
    self.seo_name = self.title.russian_translit if self.respond_to?(:seo_name) && !self.title.nil? && self.seo_name.nil?
  end
  def seos( city = nil)
    result = []
    result << (self.parent.nil? ? [self.seo_name,( city ? city.seo_name : nil)].compact.join("-") : [self.parent.seos( city ), [self.seo_name,( city ? city.seo_name : nil)].compact.join("-") ])
    result.flatten
  end

  def link( city = nil )
    "/category/#{self.seos( city ).join('/')}"
  end

  def pages_for_blog
    self.all_pages[0..3]
  end
  def all_pages
    (self.childrens.map(&:pages) + self.pages).flatten
  end
  def self.find_by_seo seo
    city_seos = City.avilables_seo
    seo.map! do |item|
      elemets = item.split("-")
      p elemets
      p city_seos & elemets
      if (city_seos & elemets).any?
        elemets = elemets[0...-1]
      end
      elemets.join("-")
    end

    category = Category.where(seo_name: seo.last).includes(:pages).first
    return false unless category
    seo.each do |s|
      return false unless category.seos.include?(s)
    end
    category
  end

  def prepare_breadcrumbs( skip_self = false, city = nil )

    prepare = lambda{ |cat, is_rec, city|
      if cat.parent.present?
        result = prepare.call(cat.parent,true, city).merge(cat.parent.bread_hash(city))
        resutl = result.merge(cat.bread_hash(city)) unless skip_self
      else
        result =  skip_self ? {} : is_rec ? {} : cat.bread_hash(city)
      end
      return result
    }
    prepare.call(self,false, city)

  end

  def bread_hash( city = nil)
    {"#{self.link(city)}" => city ? [self.title, city.name].join(" ")  : self.title}
  end

  def all_childrens
    Category.where(parent_id: self.id).all
  end

  def seo_text
    read_attribute("seo_text_#{I18n.locale}")
  end

  def self.to_tree
    get_parent.map(&:to_tree_item)
  end

  def self.get_parent
    Rails.cache.fetch("categories_parent", expires_in: 1.month) do
      Category.where(parent_id:0).includes(:childrens).order({position: :asc},{id: :asc})
    end
  end

  def self.to_tree
    to_tree_recoursive = lambda do |item|
      {
        id:        item.id,
        title:     item.title,
        parent_id: item.parent_id,
        seo:       item.seos.join("/"),
        childs:    item.childrens.map{ |item| to_tree_recoursive.call(item) },
        pages_count: item.pages.count
      }
    end

    Rails.cache.fetch("categories_tree", expires_in: 1.month) do
      Category.where(parent_id:0).map{ |item| to_tree_recoursive.call(item) }
    end
  end

  private

  def clear_cache
    Rails.cache.delete("categories_tree")
    Rails.cache.delete("categories_parent")
  end

end
