class RemoveColumnParamaters < ActiveRecord::Migration[5.1]
  def change
    add_column :paramaters,:question,:string,:after =>:Rname
  end
end
