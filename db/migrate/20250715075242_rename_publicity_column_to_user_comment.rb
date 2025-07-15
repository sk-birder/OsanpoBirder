class RenamePublicityColumnToUserComment < ActiveRecord::Migration[6.1]
  def change
    rename_column :user_comments, :publicity, :is_public
  end
end
