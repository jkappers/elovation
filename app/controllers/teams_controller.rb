class TeamsController < ApplicationController
  include ParamsCleaner

  def show
    @team = Team.find(params[:id])
  end

end
