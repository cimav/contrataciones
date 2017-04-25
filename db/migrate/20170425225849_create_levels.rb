class CreateLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :levels do |t|
      t.string :full_name
      t.string :short_name
      t.string :requirements
      t.integer :level_type

      t.timestamps
    end
  end
end
