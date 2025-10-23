class AddSalonRefToConsultations < ActiveRecord::Migration[7.2]
  def change
    add_reference :consultations, :salon, null: true, foreign_key: true
  end
end
