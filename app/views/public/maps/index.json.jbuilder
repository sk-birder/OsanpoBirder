json.data do
  json.items do
    json.array!(@posts) do |post|
      json.postId       post.id
      if post.post_images.attached?
        json.postImage    post_image_path(post, 100, 100)
      end
      json.countImage   post.post_images.count
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