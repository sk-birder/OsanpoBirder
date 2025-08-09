class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id,       null: false
      t.integer :category_id,   null: false
      t.string  :title,         null: false
      t.float   :latitude,      null: false
      t.float   :longitude,     null: false
      t.integer :prefecture,    null: false
      t.integer :month,         null: false
      t.text    :body,          null: false
      t.boolean :is_public,     null: false
      t.boolean :is_forbidden,  null: false, default: false
      t.timestamps
    end
  end
end
