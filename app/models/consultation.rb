class Consultation < ApplicationRecord
  belongs_to :user
  belongs_to :salon, optional: true
  enum :status, { draft: "draft", completed: "completed", shared: "shared", archived: "archived" }
  has_many :answers, dependent: :destroy
  has_one :consultation_sharing, dependent: :destroy
  # to_paramはこのオブジェクトのURLパラメータとしてuuid_urlをURLパラメータとして使用するという意味のメソッド
  def to_param
    uuid_url
  end

  # Ransackが検索を許可する属性を定義
  def self.ransackable_attributes(auth_object = nil)
    # Ransackによる検索を許可するカラム名（文字列の配列）を返します。
    # 提示されたエラーログに含まれるカラムをそのまま使います
    [ "created_at", "id", "salon_id", "status", "updated_at", "user_id", "uuid_url" ]
  end

  # 関連テーブルの検索を許可する属性も定義が必要
  # :user (Userモデル) のフルネームで検索するため、こちらも許可します
  def self.ransackable_associations(auth_object = nil)
    # 関連モデル名を文字列の配列で返します
    [ "user" ] # Userモデルを関連付けとして検索することを許可
  end
end
