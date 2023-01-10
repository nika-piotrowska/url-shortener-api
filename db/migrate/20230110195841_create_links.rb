class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.belongs_to :user
      t.string :link
      t.string :shortened_link, unique: true
      t.integer :click_count, null: false, default: 0
      t.timestamps
    end
  end
end
