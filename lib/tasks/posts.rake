namespace :posts do
  desc "既存の公開投稿のpublished_atにcreated_atの値を代入する"
  task backfill_published_at: :environment do
    dry_run = ENV["DRY_RUN"] == "true"
    puts 'DRY RUN MODE' if dry_run

    scope = Post.where(is_public: true, published_at: nil)
    if dry_run
      scope.find_each do |post|
        puts "#{post.id} のpublished_atが#{post.created_at} に更新されます。"
      end
      puts "更新対象は #{scope.count} 件です。"
    else
      updated_count = scope.update_all("published_at = created_at")
      puts "#{updated_count} 件の投稿データを更新しました。"
    end
  end
end
