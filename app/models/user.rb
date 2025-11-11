class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

          # フルネーム
          validates :full_name, presence: true
          validates :full_name, length: { in: 2..50 }
          # email
          validates :email, presence: true
  has_many :consultations, dependent: :destroy
  has_many :events, dependent: :destroy

  # Ransackが検索を許可する属性を定義
  def self.ransackable_attributes(auth_object = nil)
    # Ransackによる検索を許可するカラム名（文字列の配列）を返します。
    # 提示されたエラーログに含まれるカラムをそのまま使います
    %w[full_name age_group email gender id]
  end

  # 関連テーブルの検索を許可する属性も定義が必要
  # :userモデルのフルネームで検索するため、こちらも許可
  def self.ransackable_associations(auth_object = nil)
    # 関連モデル名を文字列の配列で返します
    [ "user" ] # Userモデルを関連付けとして検索することを許可
  end
end
