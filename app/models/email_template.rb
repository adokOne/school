class EmailTemplate < ActiveRecord::Base


  validates_presence_of :subject

  scope :active_template, ->(seo_name) { where(seo_name: seo_name, active: true) }


  TAGS = [
    :USERNAME,
    :EMAIL,
    :PHONE,
    :TEST_RESULT_COUNT,
    :VACANCY_NAME,
    :GROUP_NAME,
    :GROUP_DATE,
  ]

end
