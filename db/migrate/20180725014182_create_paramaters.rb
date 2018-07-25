class CreateParamaters < ActiveRecord::Migration[5.1]
  def change
    create_table :paramaters do |t| 
           
      t.integer :Rid
      t.integer :Pid
      t.string :Pname
      t.integer :key
      t.integer :format
      t.timestamps
    end
  end
end
