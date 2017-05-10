class AddLevelTypeToCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :decision_type, :integer
    add_column :candidates, :comments, :string
  end
end
