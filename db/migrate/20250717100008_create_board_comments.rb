class CreateBoardComments < ActiveRecord::Migration[6.1]
  def change
    create_table :board_comments do |t|
      t.integer :board_id,   null: false
      t.integer :admin_id,  null:false
      t.text    :body,       null:false
      t.timestamps
    end
  end
end
