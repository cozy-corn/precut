class Consultation < ApplicationRecord
  belongs_to :user

  enum status: { draft: "draft", completed: "completed", shared: "shared", archived: "archived" }
  has_many :answers, dependent: :destroy
end
