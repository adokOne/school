class Subscriber < ActiveRecord::Base


  validates :email, presence: true
  #validates :name,     length: { in: 3..50 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :email,    length: { in: 6..50 }, uniqueness: true,format:{with:/\A^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  #validates :phone,    length: { in: 6..20 }#, numericality:true
  validates :school_subscribe,:club_subscribe,:blog_subscribe, inclusion:{ in: [true,false] }
  validates :active, inclusion:{ in: [true,false] }


  belongs_to :course
  delegate :name, to: :course, prefix: true, allow_nil: true

  scope :for_school, -> { where(school_subscribe: true) }
  scope :for_club, -> { where(club_subscribe: true) }
  scope :for_blog, -> { where(blog_subscribe: true) }
  scope :active, -> { where(active: true) }



  def self.check!( params )
    subscriber = find_by_email(params[:email])
    subscriber = subscriber.present? ? subscriber : Subscriber.new
    subscriber.update_attributes(params)
    subscriber.save
    subscriber
  end

end
