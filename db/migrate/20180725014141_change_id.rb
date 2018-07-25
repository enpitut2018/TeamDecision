class ChangeId < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :id, :integer, auto_increment:true
  end
end
