module RUBG  
  class Match < RubgEndpoint
    attr_reader :match_id, :created, :duration, :mode, :map, :patch_version, :shard, :stats,
      :tags, :title_id, :telemetry_id, :rounds, :spectators, :link, :telemetry_link,
      :player_count, :roster_count, :winners, :names, :survived, :dbnos, 
      :assists, :boosts, :damage_dealt, :damage_dealt_avg, :death_types, :headshot_kills,
    :heals, :kills, :ride_distance_avg, :revives, :road_kills, :team_kills, 
    :time_survived_avg, :vehicle_destroys, :walk_distance_avg, :weapons_acquired

    attr_accessor   :rosters, :participants
    alias_method    :winner,  :winners
    alias_method    :knocks,  :dbnos

    def initialize( args )
      args                  = self.class.defaults.merge(args)
      super({
        :response => args[:response]
        })
      if args[:response]["data"]
        @match_id         = args[:match_data]["id"]
        @created          = args[:match_data]["attributes"]["createdAt"]
        @duration         = args[:match_data]["attributes"]["duration"]
        @mode             = args[:match_data]["attributes"]["gameMode"]
        @map              = convert_map_name(args[:match_data]["attributes"]["mapName"])
        @patch_version    = args[:match_data]["attributes"]["patchVersion"]
        @shard            = args[:match_data]["attributes"]["shardId"]
        @stats            = args[:match_data]["attributes"]["stats"]
        @tags             = args[:match_data]["attributes"]["tags"]
        @title_id         = args[:match_data]["attributes"]["titleId"]
        @telemetry_id     = args[:match_data]["relationships"]["assets"]["data"][0]["id"]
        @rounds           = args[:match_data]["relationships"]["rounds"]["data"]      if args[:match_data]["relationships"]["rounds"]
        @spectators       = args[:match_data]["relationships"]["spectators"]["data"]  if args[:match_data]["relationships"]["spectators"]
        @link             = args[:match_data]["links"]["self"]
        @telemetry_link   = args[:match_included].detect {|i| i["type"] == "asset" }["attributes"]["URL"]
        
        @rosters          = []
        @participants     = []
        generate_roster_objects(args[:match_included])
        

        @player_count     = @participants.count
        @roster_count     = @rosters.count
        @winners          = @rosters.detect {|r| r.won}


        #aggregates
        @names              = @participants.collect(&:name).sort!
        @survived           = @participants.select {|m| m.death_type == "alive"}
        @dbnos              = @participants.sum {|m| m.dbnos}
        @assists            = @participants.sum {|m| m.assists}
        @boosts             = @participants.sum {|m| m.boosts}
        @damage_dealt       = @participants.sum {|m| m.damage_dealt}
        @damage_dealt_avg   = ((participants.sum {|m| m.damage_dealt}).to_f/self.player_count.to_f).to_i
        @headshot_kills     = @participants.sum {|m| m.headshot_kills}
        @heals              = @participants.sum {|m| m.heals}
        @kills              = @participants.sum {|m| m.kills}
        @ride_distance_avg  = ((participants.sum {|m| m.ride_distance}).to_f/self.player_count.to_f).to_i
        @revives            = @participants.sum {|m| m.revives}
        @road_kills         = @participants.sum {|m| m.road_kills}
        @team_kills         = @participants.sum {|m| m.team_kills}
        @time_survived_avg  = ((participants.sum {|m| m.time_survived}).to_f/self.player_count.to_f).to_i
        @vehicle_destroys   = @participants.sum {|m| m.vehicle_destroys}
        @walk_distance_avg  = ((participants.sum {|m| m.walk_distance}).to_f/self.player_count.to_f).to_i
        @weapons_acquired   = @participants.sum {|m| m.weapons_acquired}
      end
    end


    def self.fetch( args )
      args                  = self.defaults.merge(args)

      endpoint = "match"
      
      match_id = args[:query_params][:match_id]
      args[:query_params].delete(:match_id)

      super({
        :client         => args[:client],
        :endpoint       => endpoint,
        :lookup_id      => match_id,
        :shard          => args[:shard],
        :query_params   => args[:query_params]
        })
      
      match_data      = @response["data"]
      match_included  = @response["included"] 
      
      RUBG::Match.new({
        :client         => args[:client],
        :response       => @response,
        :match_data     => match_data,
        :match_included => match_included
        })
    end


    private

      def self.defaults
        super
      end

      def convert_map_name (map_name)
        if map_name == "Desert_Main"
          "Miramar"
        elsif map_name == "Erangel_Main"
          "Erangel"
        else
          map_name
        end
      end


      def participant_id_array(data)
        participant_ids = []
        data.map do |pt|
          id = pt["id"]
          participant_ids << id
        end
        return participant_ids
      end


      def generate_roster_objects (i)
        rosters          = i.select {|i| i["type"] == "roster"}
        participants     = i.select {|i| i["type"] == "participant"}
        
        rosters.map do |roster|
          roster_participants = find_roster_participants({
            :roster       => roster,
            :participants => participants
            })


          roster_object = RUBG::Roster.new({
            :roster_hash        => roster,
            :participant_array  => roster_participants
            })
          @rosters << roster_object
          @participants += roster_object.participants
        end

        @rosters.sort_by! {|r| r.rank}
        @participants.sort_by! {|pt| pt.kill_place}

        return @rosters, @participants
      end


      def find_roster_participants( args )
        ids = participant_id_array(args[:roster]["relationships"]["participants"]["data"])

        roster_participants = []

        ids.map do |id|

          participant_object = args[:participants].detect {|pt| pt["id"] == id}
          roster_participants << participant_object
        end

        return roster_participants
      end

  end
end