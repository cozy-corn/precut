class Consultation < ApplicationRecord
  belongs_to :user
  belongs_to :salon, optional: true
  enum status: { draft: "draft", completed: "completed", shared: "shared", archived: "archived" }
  has_many :answers, dependent: :destroy
  has_one :consultation_sharing
  # to_paramはこのオブジェクトのURLパラメータとしてuuid_urlをURLパラメータとして使用するという意味のメソッド
  def to_param
    uuid_url
  end
end
