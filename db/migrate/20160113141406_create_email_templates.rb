class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      %w(en uk ru).each do |l|
        t.string :"subject_#{l}", null: false, default: ""
        t.text :"text_#{l}"
      end
      t.boolean :active, default: true
      t.string :seo_name, null: false
    end
  end
end
