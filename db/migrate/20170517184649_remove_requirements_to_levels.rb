class RemoveRequirementsToLevels < ActiveRecord::Migration[5.0]
  def change
    remove_column :levels, :requirements
  end
end
