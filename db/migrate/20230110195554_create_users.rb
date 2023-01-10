class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :encrypted_key
    end
    add_index :users, :encrypted_key, unique: true
  end
end
