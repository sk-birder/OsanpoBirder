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
  has_many :followers, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :followeds, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy

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
    user = User.where("(is_active = ?) AND (is_forbidden = ?)", true, false) # 退会済会員・除名済会員を除外
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
