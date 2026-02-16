class AddPublishedAtToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :published_at, :datetime, precision: 6, null: true
  end
end
