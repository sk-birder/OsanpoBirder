class Post < ApplicationRecord
  has_many_attached :post_images

  has_many :post_comments, dependent: :destroy
  has_many :likes,         dependent: :destroy
  has_many :reports,       dependent: :destroy
  belongs_to :user
  belongs_to :category

  before_validation :set_published_at, on: [ :create, :update ] 

  # 地点選択を必須にするカスタムバリデーション
  validate :location_presence

  # 必須のバリデーション
  validates :title, presence: true, length: {maximum:100}
  validates :body,  presence: true, length: {maximum:1000}

  # 無くとも良いかもしれないバリデーション
  validates :category_id, presence: true
  validates :prefecture, presence: true
  validates :month, presence: true

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
  enum month: {
    非公開: 0,
    １月: 1, ２月: 2, ３月: 3, ４月: 4, ５月: 5, ６月: 6,
    ７月: 7, ８月: 8, ９月: 9, １０月: 10, １１月: 11, １２月: 12
  }

  scope :user_published,  -> { where(is_public: true) }
  scope :user_draft,      -> { where(is_public: false) }
  scope :admin_forbidden, -> { where(is_forbidden: true) }
  scope :admin_allowed,   -> { where(is_forbidden: false) }
  scope :visible,         -> { user_published.admin_allowed }

  scope :recent,           -> { order(created_at: :desc) }
  scope :recently_updated, -> { order(updated_at: :desc) }
  scope :published_recent, -> { order(published_at: :desc) }

  # 地点選択を必須にするカスタムメソッド（バリデーションエラーメッセージを1文にするために必要）
  def location_presence
    if latitude.blank? || longitude.blank?
      # :baseを指定することで全体のエラーメッセージ（特定のカラムに対するものではない）とする。カスタムコンテキストを同時に設定
      errors.add(:base, '地点を選択してください')
    end
  end

  # posts#showでの非公開判定メソッド
  def visible_to?(user)
    return true if user.id == self.user_id
    return false if !is_public || is_forbidden
    true
  end

  def display_datetime_label
    published_at.present? ? '公開日時' : '下書き作成日時'
  end

  def display_main_datetime
    (published_at || created_at).strftime('%Y/%m/%d %H:%M')
  end

  # 投稿後の更新の有無を確認するメソッド
  def updated_after_creation?
    # ぼっち演算子でnilのときのエラーを回避
    updated_at&.>created_at
  end

  # 投稿画像の1枚目のみを表示するメソッド(posts#indexなどで使用)
  def show_first_post_image(width, height)
    post_images[0].variant(resize_to_limit: [width, height]).processed
  end

  # 検索用のメソッド
  # 入力テキストをtext, 検索方式をmethodとする
  def self.search_for(text, method)
    post = Post.visible
    if method == 'perfect'
      post.where(title: text) # 完全一致
    elsif method == 'forward'
      post.where('title LIKE ?', text + '%') # 前方一致
    elsif method == 'backward'
      post.where('title LIKE ?', '%' + text) # 後方一致
    else
      post.where('title LIKE ?', '%' + text + '%') # 部分一致
    end
  end

  # posts/showでのいいね判定メソッド
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  # 報告件数のカウント用メソッド
  def count_report
    reports.group(:detail).count
  end

  # posts/showでの報告判定メソッド
  def reported_by?(user)
    reports.exists?(user_id: user.id)
  end

  private
  def set_published_at
    return if !is_public
    return if published_at.present?
    self.published_at ||= Time.current
  end
end
