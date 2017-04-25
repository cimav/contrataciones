class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.references :department, foreign_key: true
      t.string :email
      t.integer :user_type

      t.timestamps
    end
  end
end
