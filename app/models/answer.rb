class Answer < ApplicationRecord
  belongs_to :consultation
  validates :question, presence: true
end
