class Consultation < ApplicationRecord
  belongs_to :user
  belongs_to :salon, optional: true
  enum status: { draft: "draft", completed: "completed", shared: "shared", archived: "archived" }
  has_many :answers, dependent: :destroy
  has_one :consultation_sharing
  def to_param
    uuid_url
  end
end
