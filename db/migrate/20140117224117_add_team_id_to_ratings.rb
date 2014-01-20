class AddTeamIdToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :team_id, :integer
  end
end
