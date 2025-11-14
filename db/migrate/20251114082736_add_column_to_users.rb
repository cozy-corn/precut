class AddColumnToUsers < ActiveRecord::Migration[7.2]
  # UserモデルにLINEログイン用のカラムを追加
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
