class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image #画像アップ用のメソッド（attachment）を追加してフィールド名に（profile_image:カラム名からidを抜いたもの）を指定。refileを使用するうえでのルール

  has_many :books, dependent: :destroy

  validates :name, presence: true, length: { in: 2..20 } #エラーメッセージのため
  validates :introduction, length: { maximum: 50 }
end
