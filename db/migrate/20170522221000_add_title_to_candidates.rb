class AddTitleToCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :title, :string
  end
end
