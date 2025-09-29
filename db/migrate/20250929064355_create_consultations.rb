class CreateConsultations < ActiveRecord::Migration[7.2]
  def change
    create_table :consultations do |t|
      t.references :user, null: false, foreign_key: true
      t.text :summary, null: false
      t.string :status, null: false, default: "draft"
      t.timestamps
    end
  end
end
