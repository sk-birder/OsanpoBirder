class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.integer  :poster_id, null: false
      t.boolean  :is_admin,  null: false
      t.string   :title,     null: false
      t.text     :body,      null: false
      t.boolean  :is_public, null: false
      t.timestamps
    end
  end
end
