class CreateCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :candidates do |t|
      t.string :name
      t.references :department, foreign_key: true
      t.integer :status
      t.references :level, foreign_key: true
      t.string :email
      t.string :function
      t.string :degree

      t.timestamps
    end
  end
end
