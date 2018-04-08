module RUBG
  class RubgEndpoint
    attr_reader :errors, :data, :response_ts, :ratelimit, :ratelimit_remaining, :ratelimit_reset, :raw_response

    def initialize( args )
      args                  = self.class.defaults.merge(args)
      @errors               = args[:response]["errors"]
      @data                 = args[:response]["data"]
      @response_ts          = Time.parse(args[:response].headers['date']) if args[:response].headers['date']
      @ratelimit            = args[:response].headers['x-ratelimit-limit']
      @ratelimit_remaining  = args[:response].headers['x-ratelimit-remaining']
      @ratelimit_reset      = args[:response].headers['x-ratelimit-reset'].to_i
      @raw_response         = args[:response]
    end


    def self.fetch( args ) #client,endpoint,shard={},query_params={}
      args     = self.defaults.merge(args)
      
      uri      = assemble_uri({
        :shard          => args[:shard],
        :endpoint       => args[:endpoint],
        :lookup_id      => args[:lookup_id]
        })

      headers  = assemble_headers({
        :client         => args[:client]
        })

      query    = assemble_query({
        :client         => args[:client],
        :query_params  => args[:query_params]
        })

      @response = args[:client].class.get(uri,{headers: headers,
                                        query:  query})

      return @response
    end

    def ratelimit_reset_in
      @ratelimit_reset.to_i - Time.now.to_i
    end


    private
      
      def self.defaults
        {
          :shard          => $RUBG_DEFAULT_SHARD,
          :query_params  => {},
        }
      end


      def self.assemble_uri( args )
        args     = self.defaults.merge(args)

        if args[:endpoint] == 'status'
          uri = '/status'
        elsif args[:endpoint] == 'player'
          uri = "/shards/#{args[:shard]}/players/#{args[:lookup_id]}"
        elsif args[:endpoint] == 'match'
          uri = "/shards/#{args[:shard]}/matches/#{args[:lookup_id]}"
        else
          uri = "/shards/#{args[:shard]}/#{args[:endpoint]}"
        end

        return uri
      end


      def self.assemble_headers( args ) #client
        args     = self.defaults.merge(args)

        headers = { "Accept" => args[:client].content_type }
        
        headers["Authorization"]    = args[:client].api_key   if args[:client].api_key
        headers["Accept-Encoding"]  = "gzip"                  if args[:client].gzip

        return headers
      end


      def self.assemble_query( args ) #client, query_params
        args     = self.defaults.merge(args)

        args[:query_params].each do |key,value|
          remove_spaces(value) if value
        end
        query = args[:query_params]

        return query
      end


      private
        def self.remove_spaces(string)
          string.gsub!(/((?<=,)\s+)|(\s+(?=,))/,"") if string
        end
  end
end