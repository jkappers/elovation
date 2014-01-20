class ResultTeam < ActiveRecord::Base
  belongs_to :team
  belongs_to :result
end