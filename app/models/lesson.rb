class Lesson < ActiveRecord::Base


  validates :date,:time,:course_id, presence: true
  validates :active, inclusion:{ in: [true,false] }

  belongs_to :course

  delegate :name, to: :course, prefix: true, allow_nil: true

  scope :for_school, -> { where(course_id: Course.select("id").where(course_type: Course::SCHOOL_TYPE).all.map(&:id)) }
  scope :for_club, -> { where(course_id: Course.select("id").where(course_type: Course::CLUB_TYPE).all.map(&:id) ) }
  scope :active, -> { where(active: true) }

end
