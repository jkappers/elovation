class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  
  scope :active,  ->() { select('distinct players.*').joins(:results).where('results.created_at > ?', 2.weeks.ago)}
  # attr_accessible :title, :body

  has_and_belongs_to_many :teams

  has_many :results, through: :teams do
    def against(opponent)
      joins("INNER JOIN teams AS other_teams ON results.id = other_teams.result_id")
        .joins("INNER JOIN players_teams AS other_players_teams ON other_teams.id = other_players_teams.team_id")
        .where("other_players_teams.player_id = ?", opponent)
    end
  end

  before_destroy do
    results.each { |result| result.destroy }
  end

  validates :name, :uniqueness => true, :presence => true
  validates :email, :format => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :allow_blank => true

  def as_json
    {
      :name => name,
      :email => email
    }
  end

  def recent_results
    results.order("created_at DESC").limit(5)
  end

  def rewind_rating!(game)
    rating = ratings.where(:game_id => game.id).first
    rating.rewind!
  end

  def display_name(current_player)
		return "You" if current_player && self == current_player
    self.name.split(' ')[0]
	end
  
  def ratings
    Rating.where(team_id: self.teams.select { |t| t.players.length == 1 }.map(&:id))
  end
	
	def display_name_for_result(current_player, result)
	  _name = display_name(current_player)
	  rhe = result.rating_history_events.detect { |rhe| rhe.rating.team.players.include? self }
	  return _name unless rhe
	  "#{name} (#{rhe.change > 0 ? "+#{rhe.change}" : rhe.change })"
	end
end
