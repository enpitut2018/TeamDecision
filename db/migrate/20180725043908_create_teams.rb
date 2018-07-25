class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.integer :Rid
      t.string :Tname

      t.timestamps
    end
  end
end
