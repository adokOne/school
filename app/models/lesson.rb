class Lesson < ActiveRecord::Base

  DATE_FORMAT =  "%d.%m.%Y"
  JS_DATE_FORMAT = "DD.MM.YYYY"

  validates :date,:time,:course_id, presence: true
  validates :active, inclusion:{ in: [true,false] }

  belongs_to :course

  delegate :name, to: :course, prefix: true, allow_nil: true

  scope :for_school, -> { where(course_id: Course.select("id").where(course_type: Course::SCHOOL_TYPE).all.map(&:id)) }
  scope :for_club, -> { where(course_id: Course.select("id").where(course_type: Course::CLUB_TYPE).all.map(&:id) ) }
  scope :active, -> { where(active: true) }



  def formated_date
    Date.strptime(self.date, DATE_FORMAT ).strftime("%m-%d-%Y") rescue ""
  end

  def formated_html
    "<p class=\"lesson_box\" data-course-id=\"#{self.course_id}\" data-id=\"#{self.id}\">#{self.course_name}</p> <b>#{self.time}</b>"
  end

end
