class TeamGamesController < ApplicationController
  def show
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:id])
  end
end
