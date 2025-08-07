class CreateMapTests < ActiveRecord::Migration[6.1]
  def change
    create_table :map_tests do |t|
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :title, null: false
      t.string :body, null: false
      t.timestamps
    end
  end
end
