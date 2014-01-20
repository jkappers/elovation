class Team < ActiveRecord::Base
  FIRST_PLACE_RANK = 1

  has_and_belongs_to_many :players
  has_many :result_teams
  has_many :results, :through => :result_teams
  
  has_many :ratings, :order => "value DESC", :dependent => :destroy do
    def find_or_create(game)
      where(:game_id => game.id).first || create({game: game, pro: false}.merge(game.rater.default_attributes))
    end
  end

  validates :rank, presence: true
  
  before_create :set_identifier
  
  def name
    players.map { |player| player.name.split(/\s/)[0] }.join(' & ')
  end
  
  def self.find_or_initialize_with_player_ids(player_ids)
    puts player_ids
    ident = player_ids.sort { |x,y| x.to_i <=> y.to_i }.join('_')
    puts ident
    return Team.find_by_identifier(ident) || Team.new(player_ids: player_ids)
  end
  
  def set_identifier
    self.identifier = self.players.sort { |x,y| x.id <=> y.id }.map(&:id).join('_')
  end
end
