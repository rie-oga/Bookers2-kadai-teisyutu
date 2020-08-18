class CreateRelationships < ActiveRecord::Migration[5.2]

	#userとtweetsの関係とは違い、userテーブル同士で「多対多」の関係を作る
	#フォロワーもユーザーだから。
	#userテーブル同士をrelationshipという中間テーブルでアソシエーションを組むイメージ

	#カラムは、user_id（オプション：foreign_key:true）とfollow_id(オプション：foreign_key:{to_table:users})
	#relationshipテーブルは中間テーブルのため、folloe_idとuser_idは t.references で作る必要がある
	#そして、外部キーとしての設定をするために、オプションとしてforeign_key:trueとする。ただし、follow_idの参照先テーブルはusersテーブルにしたいため、 to_table: :user とする。foreign_key:trueとすると、存在しないfollowテーブルを参照してしまう

  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps

      t.index [:user_id, :follow_id], unique: true #user_idとfollow_idペアで重複するものが保存されないように。あるユーザーがあるユーザーをフォローしたとき、フォローを解除せずに何度もフォローできてしまうような事態を防いでいる

    end
  end
end
