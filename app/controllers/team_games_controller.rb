class TeamGamesController < ApplicationController
  def show
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:id])
    @recent_results = @team.results.for_game(@game).order('results.created_at desc').includes(:teams, :rating_history_events => :rating).limit(15)
  end
end
