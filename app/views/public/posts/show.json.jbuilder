json.data do
  json.items do
    json.array!(@post_map) do |post_map|
      json.id post_map.id
      json.user do
        json.name post_map.user.name
      end
      json.title post_map.title
      json.body post_map.body
      json.latitude post_map.latitude # エラーになるはず
      json.longitude post_map.longitude # エラーになるはず
    end  
  end
end