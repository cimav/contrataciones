class AddCurriculumToCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :curriculum, :string
  end
end
