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
    puts 'Matching results to teams:'
    Team.all.each do |team|
      if team.result_id
        result = Result.find(team.result_id)
        team.results << result unless team.results.include? result
        print '.'
      end
      team.set_identifier
      team.save
    end
    
    
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
