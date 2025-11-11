class Event < ApplicationRecord
  belongs_to :user

  validates :title, :start_time, :end_time, presence: true
end
