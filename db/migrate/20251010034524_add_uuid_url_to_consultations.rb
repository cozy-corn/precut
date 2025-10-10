class AddUuidUrlToConsultations < ActiveRecord::Migration[7.2]
  def change
    # 'uuid_url'というカラムをUUID型で追加。
    # 最初は既存のレコードのために null: true (空を許容) に設定します。
    # unique: true で重複しないことを保証します。
    add_column :consultations, :uuid_url, :uuid, null: true
    add_index :consultations, :uuid_url, unique: true
  end
end
