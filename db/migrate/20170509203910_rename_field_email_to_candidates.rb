class RenameFieldEmailToCandidates < ActiveRecord::Migration[5.0]
  def change
    change_table :candidates do |t|
      t.rename :email, :sni
    end
  end
end
