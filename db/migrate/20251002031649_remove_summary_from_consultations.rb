class RemoveSummaryFromConsultations < ActiveRecord::Migration[7.2]
  def change
    remove_column :consultations, :summary, :text
  end
end
