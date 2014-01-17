class Recommender
  
  def initialize(player, game)
    @player = player
    @game = game
  end
  
  def never_played_with
    return @_never_played_with unless @_never_played_with.blank?
    previous_teams = @player.teams.includes(:players)
    other_players = previous_teams.map(&:players).flatten.uniq
    @_never_played_with = _players_not_found(other_players).all
  end
  
  def not_recently_played_with
    return @_not_recently_played_with unless @_not_recently_played_with.blank?
    previous_teams = @player.teams.where('teams.created_at > ?', 1.week.ago).includes(:players)
    other_players = (previous_teams.map(&:players).flatten + never_played_with).uniq
    @_not_recently_played_with = _players_not_found(other_players).all
  end

  def never_played_against
    return @_never_played_against unless @never_played_against.blank?
    @previous_games ||= @player.results.where(:game_id => @game.id).includes(:teams => :players)
    opponents = _opponents_from_games(@previous_games)
    @_never_played_against = _players_not_found(opponents).all
  end
  
  def not_recently_played_against
    return @_not_recently_played_against unless @_not_recently_played_against.blank?
    @previous_games ||= @player.results.where(:game_id => @game.id).includes(:teams => :players)
    recent = @previous_games.where('results.created_at > ?', 1.week.ago)
    opponents = _opponents_from_games(recent)
    @_not_recently_played_against = _players_not_found(opponents + never_played_against).all
  end
  
  def nearest_rating
    current_rating = @player.ratings.where(:game_id => @game.id).first.value
    players = Player.active.joins(:ratings).includes(:ratings).where('ratings.game_id = ? AND players.id <> ?', @game.id, @player.id)
    sorted = players.sort { |p1,p2| _rating_difference(current_rating, p1.ratings.first) <=> _rating_difference(current_rating, p2.ratings.first) }
    sorted
  end
  
  private
  
    def _rating_difference(rating1, rating2)
      (rating1 - rating2).abs
    end

    def _opponents_from_games(games)
      opponent_teams = games.map(&:teams).flatten.reject { |t| t.players.include?(@player) }
      opponents = opponent_teams.map(&:players).flatten.uniq
    end
    
    def _players_not_found(players)
      if players.blank?
        Player.active.where("players.id <> ?", @player.id)
      else
        Player.active.where("players.id not in (?)", players.map(&:id) + [@player.id])
      end
    end
  
end