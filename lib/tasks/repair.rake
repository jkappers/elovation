namespace :repair do
  desc 'Repairs all ratings'
  task :ratings => :environment do
    Game.all.each do |game|
      puts "calculating ratings for #{game.id} #{game.name}"
      puts "before: "
      game.all_ratings.each do |rating|
        participant = rating.player || rating.team
        puts "#{participant.name} - value: #{rating.value} - (mean: #{rating.trueskill_mean} deviation: #{rating.trueskill_deviation})"
      end

      game.recalculate_ratings!

      puts "after: "
      game.all_ratings.each do |rating|
        participant = rating.player || rating.team
        puts "#{participant.name} - value: #{rating.value} - (mean: #{rating.trueskill_mean} deviation: #{rating.trueskill_deviation})"
      end
    end
  end
  
  desc 'Migrate teams and results to the new static system'
  task :teams => :environment do
    puts 'Matching results to teams:'
    Team.all.each do |team|
      if team.result_id
        result = Result.find(team.result_id)
        unless ResultTeam.find_by_result_id_and_team_id(result.id, team.id)
          ResultTeam.create(:result => result, :team => team, :rank => team.rank)
        end
        print '.'
      end
      team.set_identifier
      team.save
    end
    puts
    
    team_hash = Team.all.group_by(&:identifier)
    puts "Uniqing #{team_hash.count} teams:"
    team_hash.each do |identifier, teams|
      winner = teams.shift      
      teams.each do |team|
        team.results.each do |result|
          unless winner.results.include?(result)
            rt = ResultTeam.new(:result => result, :team => winner, :rank => team.rank)
            rt.save
          end
        end
        team.destroy
      end
      winner.save
      print '.'
    end
  end
end
