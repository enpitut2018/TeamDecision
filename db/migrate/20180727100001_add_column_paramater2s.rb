class AddColumnParamater2s < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms,:RadminKey,:string
  end
end
