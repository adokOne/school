class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|


      t.string :subject
      t.string :seo_name
      t.boolean :active, default: true
      t.text   :desc,         limit: 4294967295

    end
  end
end
