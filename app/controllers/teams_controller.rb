class TeamsController < ApplicationController
  include ParamsCleaner

  def index
    @team = Team.all
  end

  def show
    @team = Team.find(params[:id])
  end

  def edit
    @team = Team.find(params[:id])
	end

	def update
		team = Team.find(params[:id])
    
		if team.players.length > 1 && team.players.select{ |p| p.id == current_player.id }.any?
			team.name = params[:team][:name]
			team.save
			Game.all.each do |game|
  			expire_fragment :controller => '/games', :action => 'show', :id => game.id
  		end
		end

		redirect_to team_path(team)
	end

end
