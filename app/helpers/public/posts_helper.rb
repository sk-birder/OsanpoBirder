module Public::PostsHelper
  def post_image_path(post, width, height)
    if post.post_images.attached?
      # url_forでURLに変換しないとimg srcが正常に機能しない
      url_for(post.post_images[0].variant(resize_to_limit: [width, height]).processed)
    else
      # url_forを行うと本番環境でフィンガープリントが付与されず404エラーになる
      asset_path('no_post_image.png')
    end
  end
end
