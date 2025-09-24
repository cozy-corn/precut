class AddColumnToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :full_name, :string, null: false
    add_column :users, :gender, :string
    add_column :users, :age_group, :string
  end
end
