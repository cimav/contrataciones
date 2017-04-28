class RemoveFieldUserReferencesToResponses < ActiveRecord::Migration[5.0]
  def change
    remove_column :responses, :user_references
  end
end
