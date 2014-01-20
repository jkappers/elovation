class Team < ActiveRecord::Base
  FIRST_PLACE_RANK = 1

  has_and_belongs_to_many :players
  has_many :result_teams
  has_many :results, :through => :result_teams

  validates :rank, presence: true
  
  before_create :set_identifier
  
  def self.find_or_initialize_with_player_ids(*player_ids)
    ident = player_ids.sort { |x,y| x.id <=> y.id }.join('_')
    return Team.find_by_identifier(ident) || Team.new(player_ids: player_ids)
  end
  
  def set_identifier
    self.identifier = self.players.sort { |x,y| x.id <=> y.id }.map(&:id).join('_')
  end
end
