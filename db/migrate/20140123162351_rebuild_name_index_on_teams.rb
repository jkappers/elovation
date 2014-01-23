class RebuildNameIndexOnTeams < ActiveRecord::Migration
  def up
  	remove_index :teams, :name
  end

  def down
    add_index :teams, :name  	
  end
end
