class ResultTeam < ActiveRecord::Base
  belongs_to :team
  belongs_to :result
  
  # default_scope { order('result_teams.rank asc') }
end