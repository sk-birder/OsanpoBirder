module Public::UsersHelper
  def hidden_prefecture_display(user)
    if user == current_user
      "#{user.prefecture}(非公開)"
    else
      '都道府県非公開'
    end
  end

  def display_prefecture_data(user)
    if user.hide_prefecture
      {
        css: 'text-white-50',
        text: hidden_prefecture_display(user)
      }
    else
      {
        css: 'text-white',
        text: user.prefecture
      }
    end
  end
end
