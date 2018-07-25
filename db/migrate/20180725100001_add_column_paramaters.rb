class AddColumnParamaters < ActiveRecord::Migration[5.1]
  def change
    remove_column :paramaters,:Pid
  end
end
