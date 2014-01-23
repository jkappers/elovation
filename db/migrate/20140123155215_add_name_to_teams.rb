class AddNameToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :name, :string
    add_index :teams, :name, unique: true
  end
end
