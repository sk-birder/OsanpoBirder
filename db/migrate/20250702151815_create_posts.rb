class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id,       null: false
      t.integer :main_class_id, null: false
      t.integer :sub_class_id,  null: false
      t.integer :area,          null: false
      t.integer :month,         null: false
      t.string  :title,         null: false
      t.text    :body,          null: false
      t.integer :publicity,     null: false
      t.timestamps
    end
  end
end
