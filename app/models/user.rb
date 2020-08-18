class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image #画像アップ用のメソッド（attachment）を追加してフィールド名に（profile_image:カラム名からidを抜いたもの）を指定。refileを使用するうえでのルール

  has_many :books, dependent: :destroy

  validates :name, presence: true, length: { in: 2..20 } #エラーメッセージのため
  validates :introduction, length: { maximum: 50 }

  has_many :relationships

  has_many :followings, through: :relationships, source: :follow
  #has_many :followingsとは、いまこのタイミングで命名したもの！followingクラス（モデル）を架空で作り出した。
#followingクラス（モデル）なんて存在しないため、補足を付け足す必要がある。
  #through: :relationships は「中間テーブルはrelationshipsだよ」と設定している。
  #source: :followとは、「relationshipsテーブルのfollow_idを参考にして、followingsモデルにアクセスしてね」って事。
  #結果として、user.followings と打つだけで、user が中間テーブル relationships を取得し、その1つ1つの relationship のfollow_idから、「フォローしている User 達」を取得しています

  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  #フォロワー（フォローされているuser達）をとってくるための記述
  #has_many :reverse_of_relationshipsは,has_many :relaitonshipsの「逆方向」って意味です。これはこのタイミングで命名したもの。reverse_of_relationshipsなんて中間テーブルは存在しません。なので、これも補足を付け足してやります。class_name: 'Relationship'で「relationsipモデルの事だよ〜」と設定してあげます。
  #foreign_key: 'follow_id'は、「relaitonshipsテーブルにアクセスする時、follow_idを入口として来てね！」っていう事です。foregin_key = 入口、source = 出口


  #フォロー機能のメソッド↓↓
  def follow(other_user)
    unless self == other_user#フォローしようとしている other_user が自分自身ではないかを検証
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
    #self には user.follow(other) を実行したとき user が代入されます。つまり、実行した User のインスタンスが self です！
    #更に、self.relationships.find_or_create_by(follow_id: other_user.id) は、見つかれば Relation を返し、見つからなければ self.relationships.create(follow_id: other_user.id) としてフォロー関係を保存(create = new + save)することができます。これにより、既にフォローされている場合にフォローが重複して保存されることがなくなります！
  end

  def unfollow(other_user) #フォローがあればアンフォローしている
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
    #relationship.destroy if relationshipは、relationship が存在すれば destroyする
  end

  def following?(other_user)
    self.followings.include?(other_user)
    #def following? では、self.followings によりフォローしている User 達を取得し、include?(other_user) によって other_user が含まれていないかを確認しています！含まれている場合には、true を返し、含まれていない場合には、false を返す
  end

end
