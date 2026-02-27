module Public::UsersHelper
  def hidden_prefecture_display(user)
    if user == current_user
      "#{user.prefecture}(非公開)"
    else
      '都道府県非公開'
    end
  end
end
