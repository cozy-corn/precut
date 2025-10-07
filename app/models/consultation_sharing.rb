class ConsultationSharing < ApplicationRecord
  belongs_to :consultation

  # トークンと相談IDへのバリデーション
  validates :shared_token, presence: true, uniqueness: true
  validates :consultation_id, uniqueness: true # 1つのカルテにつき1つの共有レコードのみ

  # レコード作成前にトークンを生成
  before_validation :generate_shared_token, on: :create

  private

  # ランダムな16進数文字列をトークンとして生成
  def generate_shared_token
    # self.shared_tokenが空の場合にのみ実行
    self.shared_token ||= SecureRandom.hex(10)
  end
end
