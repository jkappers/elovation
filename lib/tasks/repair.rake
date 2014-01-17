namespace :repair do
  task :ratings => :environment do
    Game.all.each do |game|
      puts "calculating ratings for #{game.id} #{game.name}"
      puts "before: "
      game.all_ratings.each do |rating|
        puts "#{rating.player.name} - value: #{rating.value} - (mean: #{rating.trueskill_mean} deviation: #{rating.trueskill_deviation})"
      end

      game.recalculate_ratings!

      puts "after: "
      game.all_ratings.each do |rating|
        puts "#{rating.player.name} - value: #{rating.value} - (mean: #{rating.trueskill_mean} deviation: #{rating.trueskill_deviation})"
      end
    end
  end
  
  desc 'Migrate teams and results to the new static system'
  task :teams => :environment do
    Team.all.each do |team|
      if team.result_id
        result = Result.find(team.result_id)
        team.results << result
        team.results.uniq!
        print '.'
      end
      team.set_identifier
      team.save
    end
    
    team_hash = Team.all.group_by(&:identifier)
    puts team_hash
    team_hash.each do |identifier, teams|
      puts "#{identifier}: #{teams.length}"
      winner = teams.shift
      
      teams.each do |loser|
        winner.results << loser.results
        # loser.destroy
      end
      winner.results.uniq!  
      winner.save
      puts winner.results.count
    end
  end
end
