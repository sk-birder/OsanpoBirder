class CreateCoordinates < ActiveRecord::Migration[6.1]
  def change
    create_table :coordinates do |t|
      t.integer :post_id,   null: false
      t.float   :longitude, null: false # 経度
      t.float   :latitude,  null: false # 緯度
      t.timestamps
    end
  end
end
