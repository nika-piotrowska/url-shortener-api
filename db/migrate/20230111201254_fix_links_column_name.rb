class FixLinksColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :links, :link, :long_link
  end
end
