class Salon < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # サロン名
         validates :salon_name, presence: true
  # dependent: :nullifyは、サロンが削除されたときに関連する相談のsalon_idをnullに設定します
  has_many :consultations, dependent: :nullify
end
