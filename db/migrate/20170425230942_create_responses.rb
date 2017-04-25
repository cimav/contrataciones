class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.references :user, foreign_key: true
      t.references :candidate, foreign_key: true
      t.string :user_references
      t.references :level, foreign_key: true
      t.string :comments

      t.timestamps
    end
  end
end
