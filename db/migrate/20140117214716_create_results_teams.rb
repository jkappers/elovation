class CreateResultsTeams < ActiveRecord::Migration
  def change
    create_table :results_teams do |t|
      t.integer :result_id
      t.integer :team_id
    end
  end
end
