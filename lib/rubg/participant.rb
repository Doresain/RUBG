module RUBG  
  class Participant
    attr_reader :participant_id, :actor, :shard, :dbnos, :assists, :boosts, :damage_dealt, 
    :death_type, :headshot_kills, :heals, :kill_place, :kill_ranking_before, :kill_ranking_gained, 
    :kill_streaks, :kills, :last_kill_points, :last_win_points, :longest_kill, :most_damage, 
    :name, :player_id, :revives, :ride_distance, :road_kills, :team_kills, :time_survived, 
    :vehicle_destroys, :walk_distance, :weapons_acquired, :win_place, :win_ranking_before,  
    :win_ranking_gained, :overall_ranking_gained, :stats

    alias_method :knocks, :dbnos

    def initialize( args )

      if args[:participant_hash]
        @participant_id          = args[:participant_hash]["id"]
        @actor                   = args[:participant_hash]["attributes"]["actor"]
        @shard                   = args[:participant_hash]["attributes"]["shardId"]
        @dbnos                   = args[:participant_hash]["attributes"]["stats"]["DBNOs"]
        @assists                 = args[:participant_hash]["attributes"]["stats"]["assists"]
        @boosts                  = args[:participant_hash]["attributes"]["stats"]["boosts"]
        @damage_dealt            = args[:participant_hash]["attributes"]["stats"]["damageDealt"]
        @death_type              = args[:participant_hash]["attributes"]["stats"]["deathType"]
        @headshot_kills          = args[:participant_hash]["attributes"]["stats"]["headshotKills"]
        @heals                   = args[:participant_hash]["attributes"]["stats"]["heals"]
        @kill_place              = args[:participant_hash]["attributes"]["stats"]["killPlace"]
        @kill_ranking_before     = args[:participant_hash]["attributes"]["stats"]["killPoints"]
        @kill_ranking_gained     = args[:participant_hash]["attributes"]["stats"]["killPointsDelta"].to_i
        @kill_streaks            = args[:participant_hash]["attributes"]["stats"]["killStreaks"]
        @kills                   = args[:participant_hash]["attributes"]["stats"]["kills"]
        @last_kill_points        = args[:participant_hash]["attributes"]["stats"]["lastKillPoints"]
        @last_win_points         = args[:participant_hash]["attributes"]["stats"]["lastWinPoints"]
        @longest_kill            = args[:participant_hash]["attributes"]["stats"]["longestKill"]
        @most_damage             = args[:participant_hash]["attributes"]["stats"]["mostDamage"]
        @name                    = args[:participant_hash]["attributes"]["stats"]["name"]
        @player_id               = args[:participant_hash]["attributes"]["stats"]["playerId"]
        @revives                 = args[:participant_hash]["attributes"]["stats"]["revives"]
        @ride_distance           = args[:participant_hash]["attributes"]["stats"]["rideDistance"]
        @road_kills              = args[:participant_hash]["attributes"]["stats"]["roadKills"]
        @team_kills              = args[:participant_hash]["attributes"]["stats"]["teamKills"]
        @time_survived           = args[:participant_hash]["attributes"]["stats"]["timeSurvived"]
        @vehicle_destroys        = args[:participant_hash]["attributes"]["stats"]["vehicleDestroys"]
        @walk_distance           = args[:participant_hash]["attributes"]["stats"]["walkDistance"]
        @weapons_acquired        = args[:participant_hash]["attributes"]["stats"]["weaponsAcquired"]
        @win_place               = args[:participant_hash]["attributes"]["stats"]["winPlace"]
        @win_ranking_before      = args[:participant_hash]["attributes"]["stats"]["winPoints"]
        @win_ranking_gained      = args[:participant_hash]["attributes"]["stats"]["winPointsDelta"].to_i
        @overall_ranking_gained  = ( 
          args[:participant_hash]["attributes"]["stats"]["winPointsDelta"] + 
          ( args[:participant_hash]["attributes"]["stats"]["killPointsDelta"] * 0.2)
          ).to_i
        @stats                   = args[:participant_hash]["attributes"]["stats"]

      end
    end

    private

  end
end