class AddSalonNameToSalons < ActiveRecord::Migration[7.2]
  def change
    add_column :salons, :salon_name, :string, null: false
  end
end
