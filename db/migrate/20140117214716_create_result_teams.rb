class CreateResultTeams < ActiveRecord::Migration
  def change
    create_table :result_teams do |t|
      t.integer :result_id
      t.integer :team_id
      t.integer :rank
    end
  end
end
