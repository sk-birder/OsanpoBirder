json.data do
  json.items do
    json.array!(@posts) do |post|
      json.postId           post.id
      # 投稿画像
      # if post.image.attached?
      #   json.image rails_blob_url(@drink.image) if @drink.image.attached?
      # else
      #   ダミー画像の登録
      # end
      json.user do
        # プロフィール画像 url_forでurlに変換しないとimg srcが正常に機能しない
        json.image      url_for(post.user.get_profile_image(50, 50))
        json.id         post.user.id
        json.name       post.user.name
      end
      json.category     Category.find(post.category_id).name
      json.title        post.title
      json.latitude     post.latitude
      json.longitude    post.longitude
      json.prefecture   post.prefecture
      json.month        post.month
      json.body         post.body
    end  
  end
end