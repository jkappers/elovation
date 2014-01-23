module ApplicationHelper
  def gravatar_url(player, options = {})
    options.assert_valid_keys :size
    size = options[:size] || 32
    digest = player.email.blank? ? "0" * 32 : Digest::MD5.hexdigest(player.email)
    "http://www.gravatar.com/avatar/#{digest}?d=mm&s=#{size}"
  end
  
  def team_name_for_result(team, result)
    rhe = result.rating_history_events.detect { |rhe| rhe.rating.team == team }
	  return team.name unless rhe
	  "#{team.name} (#{rhe.change > 0 ? "+#{rhe.change}" : rhe.change })"
  end
end
