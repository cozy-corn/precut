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
          # パスワード
          validates :encrypted_password, presence: true
  has_many :consultations, dependent: :destroy
end
