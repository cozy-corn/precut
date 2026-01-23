class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  # フルネーム
  validates :full_name, presence: true
  validates :full_name, length: { in: 2..50 }
  # email
  validates :email, presence: true
  # age_group
  validates :age_group, numericality: true

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
    # 関連モデル名を文字列の配列で返す
    [ "user" ] # Userモデルを関連付けとして検索することを許可
  end

  # social_profilesの中身を順番に取り出して、指定したproviderと一致する最初のsocial_profileを返す
  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  # omniauthから受け取った情報で、インスタンスの属性を設定する。
  def set_values(omniauth)
    # omniauthのproviderとuidのどちらかが既存の値と異なる場合、この時点でreturnしてメソッドを終了する。
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    # omniauthのcredentialsを取り出す
    credentials = omniauth["credentials"]
    # omniauthのinfoを取り出す
    info = omniauth["info"]
    # さっき取り出したinfoからnameを取り出す(LINEが返してくるLINEのユーザー名)
    self.full_name = info["name"]
  end

  # 引数で受け取ったraw_infoをjson化してインスタンスのraw_infoに格納する
  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
end
