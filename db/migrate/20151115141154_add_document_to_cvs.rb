class AddDocumentToCvs < ActiveRecord::Migration
  def change
    add_attachment :cvs, :document
  end
end
