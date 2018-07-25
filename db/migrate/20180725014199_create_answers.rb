class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|    
      t.integer :Aid
      t.integer :Pid
      t.integer :Uid
      t.integer :answer
      t.timestamps
    end
  end
end
