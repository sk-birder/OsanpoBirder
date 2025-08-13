json.data do
  json.items do
    json.array!(@posts) do |post|
      json.postId       post.id
      if post.post_images.attached?
        # url_forでURLに変換しないとimg srcが正常に機能しない
        json.postImage    url_for(post.get_image_in_map(100,100))
      else
        # url_forを行うと本番環境でフィンガープリントが付与されず404エラーになる
        json.postImage    ActionController::Base.helpers.asset_path('no_post_image.png')
      end
      json.category     Category.find(post.category_id).name
      json.title        post.title
      json.latitude     post.latitude
      json.longitude    post.longitude
      json.prefecture   post.prefecture
      json.month        post.month
      json.body         post.body
      json.user do
        json.image      url_for(post.user.get_profile_image(50, 50)) # url_forでURLに変換しないとimg srcが正常に機能しない
        json.id         post.user.id
        json.name       post.user.name
      end
    end  
  end
end