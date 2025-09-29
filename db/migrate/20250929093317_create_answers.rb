class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.references :consultation, null: false, foreign_key: true
      t.string :question, null: false
      t.text :answer

      t.timestamps
    end
  end
end
