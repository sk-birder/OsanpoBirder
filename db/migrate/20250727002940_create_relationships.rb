class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_user_id, null: false
      t.integer :followed_user_id, null: false
      t.timestamps
    end
  end
end
