class FixDatabase < ActiveRecord::Migration
  def change
    rename_table :courses, :products
    remove_column :products, :course_type
    remove_column :products, :date_start
    remove_column :products, :seo
    rename_table :cvs, :feedbacks
    remove_column :feedbacks, :document_file_name
    remove_column :feedbacks, :document_content_type
    remove_column :feedbacks, :document_file_size
    remove_column :feedbacks, :document_updated_at


    remove_column :subscribers, :school_subscribe
    remove_column :subscribers, :club_subscribe
    remove_column :subscribers, :blog_subscribe
    remove_column :subscribers, :course_id


    rename_table :teachers, :members
    remove_column :members, :is_in_school
    remove_column :members, :is_in_club
  end
end
