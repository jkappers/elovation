class DashboardController < ApplicationController
  def show
    @players = Player.all
    @games = Game.all
    if @games.count == 1
      redirect_to game_path(@games.first)
    end
  end
end
