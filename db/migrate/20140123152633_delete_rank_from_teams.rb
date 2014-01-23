class DeleteRankFromTeams < ActiveRecord::Migration
  def up
  	remove_column :teams, :rank
  end

  def down
  	add_column :teams, :rank, :integer
  end
end
