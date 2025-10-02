class CreateConsultationSharings < ActiveRecord::Migration[7.2]
  def change
    create_table :consultation_sharings do |t|
      t.references :consultation, null: false, foreign_key: true
      t.string :shared_token
      t.datetime :expires_at

      t.timestamps
    end
    add_index :consultation_sharings, :shared_token, unique: true
  end
end
