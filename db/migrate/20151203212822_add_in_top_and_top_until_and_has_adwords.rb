class AddInTopAndTopUntilAndHasAdwords < ActiveRecord::Migration
  def change

    add_column :pages, :has_adwords, :boolean, default: false
    add_column :pages, :in_top, :boolean,  default: false
    add_column :pages, :top_until, :date
    add_column :pages, :adwords_untilm, :date
    add_column :pages, :top_set_date, :date

  end
end
