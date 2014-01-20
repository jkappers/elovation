class RecommendationsController < ApplicationController
  def index
    @game = Game.find(params[:game_id])
    recommender = Recommender.new(current_player, @game)
    [:never_played_with, :not_recently_played_with, :never_played_against, :not_recently_played_against, :nearest_rating].each do |meth|
      self.instance_variable_set("@#{meth}", recommender.send(meth)[0..2])
    end
  end
end
