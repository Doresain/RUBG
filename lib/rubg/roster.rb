module RUBG  
  class Roster
    attr_reader :roster_id, :shard, :team_id, :team, :rank, :won, :participant_ids, :size,
    :names, :survived, :dbnos, :assists, :boosts, :damage_dealt, :damage_dealt_avg, :death_types, :headshot_kills,
    :heals, :kills, :ride_distance, :ride_distance_avg, :revives, :road_kills, :team_kills, :time_survived, 
    :time_survived_avg, :vehicle_destroys, :walk_distance, :walk_distance_avg, :weapons_acquired

    attr_accessor :participants
    alias_method :player_count, :size
    alias_method :knocks, :dbnos

    def initialize( args )

      if args[:roster_hash]
        @roster_id        = args[:roster_hash]["id"]
        @shard            = args[:roster_hash]["attributes"]["shardId"]
        @team_id          = args[:roster_hash]["attributes"]["stats"]["teamId"]
        @team             = args[:roster_hash]["relationships"]["team"]["data"]
        @rank             = args[:roster_hash]["attributes"]["stats"]["rank"]
        @won              = args[:roster_hash]["attributes"]["won"] == "true" ? true : false
        @participants     = []
        generate_participant_objects(args[:participant_array])
        @size             = @participants.count

        #aggregate roster stats
        @names              = @participants.collect(&:name)
        @survived           = @participants.select {|m| m.death_type == "alive"}
        @dbnos              = @participants.sum {|m| m.dbnos}
        @assists            = @participants.sum {|m| m.assists}
        @boosts             = @participants.sum {|m| m.boosts}
        @damage_dealt       = @participants.sum {|m| m.damage_dealt}
        @damage_dealt_avg   = ((participants.sum {|m| m.damage_dealt}).to_f/self.size.to_f).to_i
        @death_types        = @participants.collect(&:death_type)
        @headshot_kills     = @participants.sum {|m| m.headshot_kills}
        @heals              = @participants.sum {|m| m.heals}
        @kills              = @participants.sum {|m| m.kills}
        @ride_distance      = @participants.sum {|m| m.ride_distance}
        @ride_distance_avg  = ((participants.sum {|m| m.ride_distance}).to_f/self.size.to_f).to_i
        @revives            = @participants.sum {|m| m.revives}
        @road_kills         = @participants.sum {|m| m.road_kills}
        @team_kills         = @participants.sum {|m| m.team_kills}
        @time_survived      = @participants.sum {|m| m.time_survived}
        @time_survived_avg  = ((participants.sum {|m| m.time_survived}).to_f/self.size.to_f).to_i
        @vehicle_destroys   = @participants.sum {|m| m.vehicle_destroys}
        @walk_distance      = @participants.sum {|m| m.walk_distance}
        @walk_distance_avg  = ((participants.sum {|m| m.walk_distance}).to_f/self.size.to_f).to_i
        @weapons_acquired   = @participants.sum {|m| m.weapons_acquired}
      end
    end


    def won?
      @won
    end

    private

      def participant_id_array(data)
        participant_ids = []

        data.each do |pt|
          id = pt["id"]
          participant_ids << id
        end

        return participant_ids
      end

      def generate_participant_objects(participants)
        participants.map do |participant|
          participant_object = RUBG::Participant.new({
            :participant_hash => participant
            })

          @participants << participant_object
        end
      
        @participants.sort_by! {|pt| pt.name}

        return @participants
      end

  end
end