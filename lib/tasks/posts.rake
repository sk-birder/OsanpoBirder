namespace :posts do
  desc "既存の公開投稿のpublished_atにcreated_atの値を代入する"
  task backfill_published_at: :environment do
    dry_run = ENV["DRY_RUN"] == "true"
    puts 'DRY RUN MODE' if dry_run
    # 未完成 テスト前に調整すること
    Post.where(is_public: true).find_each do |post|
      if dry_run
        puts '##{post.id}が更新されます。'
      else
        post.update!(published_at: post.created_at)
      end
    end
  end

end
