module RUBG 
  class Player < RubgEndpoint
    attr_reader :player_id, :name, :created, :updated, :patch_version, :shard, :stats,
      :title_id, :assets, :match_ids, :link

    attr_accessor :matches

    def initialize( args )
      args                  = self.class.defaults.merge(args)
      super({
        :response => args[:response]
        })
      if args[:response]["data"]
        @player_id      = args[:player_data]["id"]
        @name           = args[:player_data]["attributes"]["name"]
        @created        = args[:player_data]["attributes"]["createdAt"]
        @updated        = args[:player_data]["attributes"]["updatedAt"]
        @patch_version  = args[:player_data]["attributes"]["patchVersion"]
        @shard          = args[:player_data]["attributes"]["shardId"]
        @stats          = args[:player_data]["attributes"]["stats"]
        @title_id       = args[:player_data]["attributes"]["titleId"]
        @assets         = args[:player_data]["relationships"]["assets"]["data"]
        @match_ids      = match_id_array(args[:player_data]["relationships"]["matches"]["data"])
        @matches        = nil
        @link           = args[:player_data]["links"]["self"]
      end
    end


    def self.fetch( args )
      args                  = self.defaults.merge(args)

      endpoint = "player"
      
      player_id = args[:query_params][:player_id]
      args[:query_params].delete(:player_id)

      super({
        :client         => args[:client],
        :endpoint       => endpoint,
        :lookup_id      => player_id,
        :shard          => args[:shard],
        :query_params  => args[:query_params]
        })
      
      player_data = @response["data"]
      
      RUBG::Player.new({
        :client       => args[:client],
        :response     => @response,
        :player_data  => player_data
        })
    end


    private

    def match_id_array(data)
      match_ids = []

      data.each do |m|
        id = m["id"]
        match_ids << id
      end

      return match_ids
    end


    def self.defaults
      super
    end

  end
end