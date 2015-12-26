class WpPost < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "uex_db"

  )
end
class WpPostmeta < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "uex_db"

  )
end
class WpPost < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "uex_db"

  )
  has_many :wp_term_relationships, :foreign_key => :object_id, :primary_key => :ID
  has_many :wp_postmetas, :foreign_key => :post_id, :primary_key => :ID
end

class WpPostmeta < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "uex_db"

  )
  belongs_to :wp_post, :foreign_key => :post_id, :primary_key => :ID
end

class WpOption < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "uex_db"

  )
end



class WpTerm< ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "uex_db"

  )
  has_many :wp_term_relationship, :foreign_key => :term_taxonomy_id , :primary_key => :term_id
  has_one :wp_term_taxonomyie, :foreign_key => :term_id
  has_many :wp_posts, :through =>:wp_term_relationship
end
class WpTermTaxonomyie< ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "uex_db"

  )


end
class WpTermRelationship< ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "uex_db"

  )

  belongs_to :wp_post, :primary_key => :ID, :foreign_key => :object_id
  belongs_to :wp_term, :primary_key => :term_id , :foreign_key => :term_taxonomy_id

end

AUTHOR_ALIAS = {
  12 => 2, # marina-ustinova@mail.ru
  10 => 3, # frontend@uex.link
  9 => 4, # info@uex.link
  8 => 5, # seo@uex.link
  1 => 6, # text@uex.link
  7 => 7, # it@uex.link
  10 => 8, # smm@uex.link
  13 => 9 #admin@uex.link
}
namespace :import do


  desc "Import category seo"
  task :category_seo => :environment do
    require 'php_serialize'
    data = WpOption.where(option_name: "wpseo_taxonomy_meta").first.option_value
    data = PHP.unserialize(data)
    data["category"].each_pair do |id, data|
      if category = Category.find_by_old_id(id)
        _item = {}
        # p data["wpseo_bctitle"].to_s.force_encoding("UTF-8")
        # p "/"*200
        I18n.available_locales.each do |l|
          _item["meta_desc_#{l}"] = data["wpseo_desc"].to_s.force_encoding("UTF-8")
          _item["meta_keys_#{l}"] = data["wpseo_metakey"].to_s.force_encoding("UTF-8")
          _item["meta_title_#{l}"] = data["wpseo_title"].to_s.force_encoding("UTF-8")
          # _item["focuskw_#{l}"] =
        end
        category.update_attributes( _item )
      end
    end
  end


  desc "Import cities"
  task :cities => :environment do
    cities = []
    ["Бровары", "Винница", "Виноградово", "Днепропетровск", "Житомир", "Запорожье", "Ивано-Франковск", "Киев", "Комсомольск", "Луцк", "Львов", "Одесса", "Полтава", "Ровно", "Сумы", "Тернополь", "Ужгород", "Харьков", "Херсон", "Хмельницкий", "Черкассы", "Чернигов", "Черновцы"].each do |item|
      _item ={
        country_id: Country::UKRAINE_ID,
      }
      I18n.available_locales.each do |l|
        _item["name_#{l}"] = item
      end
      cities << _item
    end
    City.transaction do
      City.delete_all
      cities.each do |item|
        city = City.create(item)
      end
    end
  end

  desc "Pages"
  task :pages => :environment do
    i = 0
    Page.delete_all
    WpPost.order("ID DESC").where(post_type: "post").each do |item|
      next unless  %w{pending publish}.include?(item.post_status)
      content = item.post_content

      # if content.match(/<img class=".*size-full.*" .* src=\"(.*?)\".*\/>/)
      #   i += 1
      #   p i
      # end
      # next

      _item = {
        admin_id: AUTHOR_ALIAS[item],
        slug: item.post_name,
        title: item.post_title,
        desc: item.post_content,
        active: %w{publish}.include?(item.post_status),
        old_id: item.ID,
        city_id: 0,
        country_id: Country::UKRAINE_ID,
        user_id: 1,
        created_at: item.post_date,
      }

      item.wp_term_relationships.each do |rel|
        if rel.wp_term.wp_term_taxonomyie.try(:taxonomy) == "category"
          _item[:category_id] = Category.find_by_old_id(rel.wp_term.term_id).id
        end
      end
      page = Page.create(_item)
      unless page.valid?
        p page.errors
        p item
      end
    end
  end

  desc "Post meta"
  task :post_meat => :environment do
      i = 0
    WpPost.order("ID DESC").where(post_type: "post").each do |item|
      next unless  %w{pending publish}.include?(item.post_status)

      _item = {}
      if elem = item.wp_postmetas.where(meta_key: "_yoast_wpseo_focuskw").first
        i +=1
        _item[:focuskw] = elem.meta_value
      end

      if elem = item.wp_postmetas.where(meta_key: "_yoast_wpseo_metadesc").first
        _item[:meta_desc] = elem.meta_value
      end

      if elem = item.wp_postmetas.where(meta_key: "_yoast_wpseo_title").first
        _item[:meta_title] = elem.meta_value
      end

      if elem = item.wp_postmetas.where(meta_key: "_yoast_wpseo_metakeywords").first
        _item[:meta_keys] = elem.meta_value
      end


      if page = Page.find_by_old_id(item.ID)
        page.update_attributes(_item)
        p
      end


      # item.wp_term_relationships.each do |rel|
      #   if rel.wp_term.wp_term_taxonomyie.try(:taxonomy) == "category"
      #     _item[:category_id] = Category.find_by_old_id(rel.wp_term.term_id).id
      #   end
      # end
      # page = Page.create(_item)
      # unless page.valid?
      #   p page.errors
      #   p item
      # end
    end
  end


  desc "Pages"
  task :blog_pages => :environment do
    i = 0
    BlogPage.delete_all
    WpPost.order("ID DESC").where(post_type: "post").each do |item|
      next unless  %w{pending publish}.include?(item.post_status)


      item.wp_term_relationships.each do |rel|
        if rel.wp_term.wp_term_taxonomyie.try(:taxonomy) == "category" && rel.wp_term.term_id ==  381
          _item = {
            admin_id: AUTHOR_ALIAS[item],
            admin_update_id: AUTHOR_ALIAS[item],
            slug: item.post_name,
            title: item.post_title,
            desc: item.post_content,
            active: %w{publish}.include?(item.post_status),
            old_id: item.ID,
            created_at: item.post_date,
          }
          page = BlogPage.create(_item)
          unless page.valid?
            p page.errors
            p item
          end
        end
      end

    end
  end




  desc "Import categories"
  task :categories => :environment do
    categories = []

    WpTerm.order_by("ID DESC").all.each do |item|
      if item.wp_term_taxonomyie.try(:taxonomy) == "category"
        if item.wp_posts.count.zero?
          p item
        end
        categories << item
      end
    end
    categories
  end
  desc "Import old db"
  task :data => :environment do
    categories = []
    Category.delete_all
    WpTerm.all.each do |item|

      if item.wp_term_taxonomyie.try(:taxonomy) == "category"
        categories << item
      end
    end

    categories.each do |item|

      _item = {
        seo_name: item.slug,
        old_id: item.term_id,
        old_parent: item.wp_term_taxonomyie.try(:parent)
      }

      I18n.available_locales.each do |l|
        _item["title_#{l}"] = item.name
        _item["desc_#{l}"] = item.wp_term_taxonomyie.try(:description)
      end
      Category.create(_item)
      p "*"*100
    end
    # categories.group_by do |item|
    #   item.slug.split("-").last
    # end.each_pair do |city, data|
    #   p city
    #   p data
    # end
  end
end
