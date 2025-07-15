class Post < ApplicationRecord
  has_many :coordinates,   dependent: :destroy
  has_many :user_comments, dependent: :destroy
  has_many :likes,         dependent: :destroy
  has_many :reports,       dependent: :destroy
  belongs_to :user

  # 必須のバリデーション
  validates :title, presence: true, length: {maximum:100}
  validates :body, presence: true, length: {maximum:1000}

  # 無くとも良いかもしれないバリデーション
  validates :main_class_id, presence: true
  validates :sub_class_id, presence: true
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

  # 検索用のメソッド
  # 入力テキストをtext, 検索方式をmethodとする
  def self.search_for(text, method)
    post = Post.where("(is_public = ?) AND (is_forbidden = ?)", true, false) # 投稿者非公開と管理者非公開を除外
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
end
