class CreateSubClasses < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_classes do |t|
      t.integer :main_class_id, null: false
      t.string  :name,          null: false
      t.timestamps
    end
  end
end
