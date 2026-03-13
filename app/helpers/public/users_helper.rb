module Public::UsersHelper
  def prefecture_display_data(user)
    if user.hide_prefecture
      text = 
        if user == current_user
          "#{user.prefecture}(非公開)"
        else
          '都道府県非公開'
        end
      { css: 'text-white-50', text: text }
    else
      { css: 'text-white', text: user.prefecture }
    end
  end

  def birth_year_display_data(user)
    if user.hide_birth_year
      text = 
        if user == current_user
          "#{user.birth_year}年(非公開)"
        else
          '誕生年非公開'
        end
      { css: 'text-white-50', text: text }
    else
      { css: 'text-white', text: "#{user.birth_year}年" }
    end
  end
end
