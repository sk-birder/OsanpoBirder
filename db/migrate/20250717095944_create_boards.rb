class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.integer  :admin_id,  null: false
      t.string   :title,     null: false
      t.text     :body,      null: false
      t.timestamps
    end
  end
end
