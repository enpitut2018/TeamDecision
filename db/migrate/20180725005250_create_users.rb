class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :id , auto_increment: true
      t.integer :Rid
      t.string :name
      t.string :email
      t.integer :key
      t.integer :Tid

      t.timestamps
    end
  end
end
