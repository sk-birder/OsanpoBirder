byebug
# これはindexアクションのjbuilderです
json.data do
  json.items do
    json.array!(@map_tests) do |map_test|
      json.id map_test.id
      json.title map_test.title
      json.body map_test.body
      json.latitude map_test.latitude
      json.longitude map_test.longitude
    end  
  end
end