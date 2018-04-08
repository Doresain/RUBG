module RUBG 
  class PlayerCollection < RubgEndpoint
    attr_reader :players

    def initialize( args )
      args     = self.class.defaults.merge(args)

      super
      
      @players = []
      if args[:response]["data"]
        args[:response]["data"].each do |player_data|
          player = RUBG::Player.new({
            :client       => args[:client],
            :response     => args[:response],
            :player_data  => player_data
            })
          

          @players << player
        end
      end
    end


    def self.fetch( args )
      args     = self.defaults.merge(args)

      endpoint = "players"

      args[:query_params]["filter[playerNames]"] = args[:query_params].delete(:player_names)
      args[:query_params]["filter[playerIds]"]   = args[:query_params].delete(:player_ids)
      super({
        :client         => args[:client],
        :endpoint       => endpoint,
        :shard          => args[:shard],
        :query_params  => args[:query_params]
        })

      RUBG::PlayerCollection.new({
        :client   => args[:client],
        :response => @response
        })
    end


    private

      def self.defaults
        super
      end

  end
end