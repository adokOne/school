class Category < ActiveRecord::Base
  #include Localizable
  BLOG_LIMIT = 4
  # #includes :parent
  before_validation :generate_seo
  #Relations
  has_many   :pages, dependent: :restrict_with_exception
  has_many   :childrens, class_name:Category, foreign_key: :parent_id, dependent: :restrict_with_exception
  belongs_to :parent, class_name: Category, foreign_key: :parent_id

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
  def seos
    result = []
    result << (self.parent.nil? ? [self.seo_name] : [self.parent.seos,self.seo_name])
    result.flatten
  end

  def pages_for_blog
    self.pages.limit(BLOG_LIMIT).order(created_at: :desc)
  end
  def all_pages
    (self.childrens.map(&:pages) + self.pages).flatten
  end
  def self.find_by_seo seo
    category = Category.where(seo_name: seo.last).includes(:pages).first
    return false unless category
    seo.each do |s|
      return false unless category.seos.include?(s)
    end
    category
  end

  def all_childrens
    Category.where(parent_id: self.id).all
  end

  def self.to_tree
    get_parent.map(&:to_tree_item)
  end

  def self.get_parent
    Category.where(parent_id:0).order({position: :asc},{id: :asc})
  end

  def self.to_tree
    to_tree_recoursive = lambda do |item|
      {
        id:        item.id,
        title:     item.title,
        parent_id: item.parent_id,
        seo:       item.seos.join("/"),
        childs:    item.childrens.map{ |item| to_tree_recoursive.call(item) }
      }
    end
    Category.where(parent_id:0).map{ |item| to_tree_recoursive.call(item) }
  end

end
