module RUBG 
  class Telemetry < RubgEndpoint
    attr_reader :raw_telemetry
    attr_accessor 

    def initialize( args )
      args                  = self.class.defaults.merge(args)
      if args[:response]
        @raw_telemetry = args[:response]
      end
    end


    def self.fetch( args )
      args                  = self.defaults.merge(args)

      endpoint = "telemetry"
      
      telemetry_link = args[:query_params][:telemetry_link]
      args[:query_params].delete(:telemetry_link)

      super({
        :client         => args[:client],
        :endpoint       => endpoint,
        :lookup_id      => telemetry_link,
        :shard          => args[:shard],
        :query_params   => args[:query_params]
        })
      
      RUBG::Telemetry.new({
        :client       => args[:client],
        :response     => @response
        })
    end

    def to_file( args )
      File.open("#{args[:location]}#{self.raw_telemetry[0]['MatchId']}.json","w") do |f|
        f.write(@raw_telemetry.to_json)
      end
    end

    private

      def self.defaults
        super
      end

  end
end