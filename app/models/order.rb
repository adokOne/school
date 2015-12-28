class Order < ActiveRecord::Base


  belongs_to :user
  belongs_to :product
  #belongs_to :transaction
  belongs_to :page
  belongs_to :admin, class_name: "B1Admin::User", foreign_key: :admin_id

  STATUS_CREATED = 0
  STATUS_SUCCESS = 1
  STATUS_PROGRESS = 2

  validates :status, inclusion:{ in: [STATUS_CREATED,STATUS_SUCCESS,STATUS_PROGRESS] }



  before_save :process
  after_save :update_cache



  def process
    if !self.start_date.present? &&  self.changes["status"].present? && self.changes["status"].last != self.changes["status"].first && self.changes["status"].last == STATUS_SUCCESS
      self.start_date = Date.today
    end
  end

  def update_cache
    if self.page.present?
      self.page.touch
    end
    if self.user.present?
      self.user.touch
    end
  end


  def self.update_pages
    Order.where(status: STATUS_SUCCESS ).each do |order|
      if order.page.present?
        if order.page.is_vip && !order.page.is_vip_db
          order.page.update_attributes(
            is_vip_db: true,
            is_vip_db_date: order.start_date
          )
        end
        if order.page.has_main_top && !order.page.has_main_top_db
          order.page.update_attributes(
            has_main_top_db: true,
            has_main_top_db_date: order.start_date
          )
        end
        if order.page.has_city_top && !order.page.has_city_top_db
          order.page.update_attributes(
            has_city_top_db: true,
            has_city_top_db_date: order.start_date
          )
        end
        if order.page.has_category_top && !order.page.has_category_top_db
          order.page.update_attributes(
            has_category_top_db: true,
            has_category_top_db_date: order.start_date
          )
        end

        if !order.page.is_vip && order.page.is_vip_db
          order.page.update_attributes(
            is_vip_db: false,
            is_vip_db_date: nil
          )
        end
        if !order.page.has_main_top && order.page.has_main_top_db
          order.page.update_attributes(
            has_main_top_db: false,
            has_main_top_db_date: order.start_date
          )
        end
        if !order.page.has_city_top && order.page.has_city_top_db
          order.page.update_attributes(
            has_city_top_db: false,
            has_city_top_db_date: nil
          )
        end
        if !order.page.has_category_top && order.page.has_category_top_db
          order.page.update_attributes(
            has_category_top_db: false,
            has_category_top_db_date: nil
          )
        end



      end
    end
  end
end
