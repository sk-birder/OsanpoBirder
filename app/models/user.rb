class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image

  has_many :posts,          dependent: :destroy
  has_many :post_comments,  dependent: :destroy
  has_many :likes,          dependent: :destroy
  has_many :reports,        dependent: :destroy
  has_many :followers, class_name: 'Relationship', foreign_key: 'follower_user_id', dependent: :destroy
  has_many :followeds, class_name: 'Relationship', foreign_key: 'followed_user_id', dependent: :destroy

  validates :email,
    format: { with: Devise.email_regexp },
    presence: true,
    uniqueness: { case_sensitive: false }
  validates :name, uniqueness: true, length: {minimum: 2, maximum: 20}
  validates :introduction, length: {maximum: 200}

  enum prefecture: {
    北海道: 1, 青森県: 2, 岩手県: 3, 宮城県: 4, 秋田県: 5, 山形県: 6, 福島県: 7,
    茨城県: 8, 栃木県: 9, 群馬県: 10, 埼玉県: 11, 千葉県: 12, 東京都: 13, 神奈川県: 14, 
    新潟県: 15, 富山県: 16, 石川県: 17, 福井県: 18,
    山梨県: 19, 長野県: 20, 岐阜県: 21, 静岡県: 22, 愛知県: 23,
    三重県: 24, 滋賀県: 25, 京都府: 26, 大阪府: 27, 兵庫県: 28, 奈良県: 29, 和歌山県: 30,
    鳥取県: 31, 島根県: 32, 岡山県: 33, 広島県: 34, 山口県: 35,
    徳島県: 36, 香川県: 37, 愛媛県: 38, 高知県: 39,
    福岡県: 40, 佐賀県: 41, 長崎県: 42, 熊本県: 43, 大分県: 44, 宮崎県: 45, 鹿児島県: 46, 沖縄県: 47
  }

  # プロフィール画像用
  def get_profile_image(width, height)
    # unless profile_image.attached?
    #   file_path = Rails.root.join('app/assets/images/test1.jpg')
    #   profile_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    # end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # 検索用のメソッド
  # 入力テキストをtext, 検索方式をmethodとする
  def self.search_for(text, method)
    user = User.where('is_active = ?', true) # 退会済会員・除名済会員を除外
    if method == 'perfect'
      user.where(name: text) # 完全一致
    elsif method == 'forward'
      user.where('name LIKE ?', text + '%') # 前方一致
    elsif method == 'backward'
      user.where('name LIKE ?', '%' + text) # 後方一致
    else
      user.where('name LIKE ?', '%' + text + '%') # 部分一致
    end
  end

  # users#showでのフォロー済み判定メソッド
  def followed_by?(user)
    followeds.exists?(follower_user_id: user.id)
  end

  # posts#newとmaps#indexの地図の初期位置設定
  def default_map_position(prefecture_name)
    prefecture_positions = {
      '北海道' => { lat: 43.0575, lng: 141.3524 },
      '青森県' => { lat: 40.8245, lng: 140.7405 },
      '岩手県' => { lat: 39.7036, lng: 141.1527 },
      '宮城県' => { lat: 38.2682, lng: 140.8701 },
      '秋田県' => { lat: 39.7186, lng: 140.1024 },
      '山形県' => { lat: 38.2554, lng: 140.3396 },
      '福島県' => { lat: 37.7503, lng: 140.4676 },
      '茨城県' => { lat: 36.3418, lng: 140.4468 },
      '栃木県' => { lat: 36.5657, lng: 139.8824 },
      '群馬県' => { lat: 36.3912, lng: 139.0601 },
      '埼玉県' => { lat: 35.8569, lng: 139.6489 },
      '千葉県' => { lat: 35.6047, lng: 140.1233 },
      '東京都' => { lat: 35.6895, lng: 139.6917 },
      '神奈川県' => { lat: 35.4478, lng: 139.6425 },
      '新潟県' => { lat: 37.9024, lng: 139.0232 },
      '富山県' => { lat: 36.6953, lng: 137.2114 },
      '石川県' => { lat: 36.5946, lng: 136.6256 },
      '福井県' => { lat: 36.0654, lng: 136.2217 },
      '山梨県' => { lat: 35.6642, lng: 138.5684 },
      '長野県' => { lat: 36.6514, lng: 138.181 },
      '岐阜県' => { lat: 35.3912, lng: 136.7222 },
      '静岡県' => { lat: 34.9756, lng: 138.3831 },
      '愛知県' => { lat: 35.1802, lng: 136.9065 },
      '三重県' => { lat: 34.7303, lng: 136.5086 },
      '滋賀県' => { lat: 35.0045, lng: 135.8685 },
      '京都府' => { lat: 35.0212, lng: 135.7556 },
      '大阪府' => { lat: 34.6863, lng: 135.520 },
      '兵庫県' => { lat: 34.6913, lng: 135.183 },
      '奈良県' => { lat: 34.6851, lng: 135.8048 },
      '和歌山県' => { lat: 34.2263, lng: 135.1675 },
      '鳥取県' => { lat: 35.5034, lng: 134.2383 },
      '島根県' => { lat: 35.4723, lng: 133.0505 },
      '岡山県' => { lat: 34.6617, lng: 133.9195 },
      '広島県' => { lat: 34.3965, lng: 132.4596 },
      '山口県' => { lat: 34.1857, lng: 131.4706 },
      '徳島県' => { lat: 34.0657, lng: 134.5593 },
      '香川県' => { lat: 34.3421, lng: 134.0434 },
      '愛媛県' => { lat: 33.8417, lng: 132.7656 },
      '高知県' => { lat: 33.5597, lng: 133.5311 },
      '福岡県' => { lat: 33.5904, lng: 130.4017 },
      '佐賀県' => { lat: 33.2494, lng: 130.2988 },
      '長崎県' => { lat: 32.7448, lng: 129.8738 },
      '熊本県' => { lat: 32.7876, lng: 130.7416 },
      '大分県' => { lat: 33.2382, lng: 131.6125 },
      '宮崎県' => { lat: 31.9111, lng: 131.4239 },
      '鹿児島県' => { lat: 31.5601, lng: 130.558 },
      '沖縄県' => { lat: 26.2124, lng: 127.6809 }
    }
    # 引数として受け取った都道府県名で検索し、見つからない場合は東京を返す
    prefecture_positions[prefecture_name] || prefecture_positions['東京都']
  end

  # ゲスト機能用
  GUEST_USER_EMAIL = 'guest@guest'

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.name = 'ゲストユーザー'
      user.password = SecureRandom.urlsafe_base64
      user.prefecture = '東京都'
      user.hide_prefecture = false
      user.birth_year = 2000
      user.hide_birth_year = false
      user.introduction = 'プロフィール見本'
      user.is_active = true
      user.is_forbidden = false
      # 画像登録
      file_path = Rails.root.join('app/assets/images/guest.png')
      user.profile_image.attach(io: File.open(file_path), filename: 'guest.png', content_type: 'image/png')
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end
end
