module RUBG
  class RubgEndpoint
    attr_reader :errors, :data, :response_ts, :ratelimit, :ratelimit_remaining, :raw_response, :query

    def initialize(client,response,query)
      @errors               = response["errors"]
      @data                 = response["data"]
      @response_ts          = Time.parse(response.headers['date']) if response.headers['date']
      @ratelimit            = response.headers['x-ratelimit-limit']
      @ratelimit_remaining  = response.headers['x-ratelimit-remaining']
      @raw_response         = response
      @query = query
    end


    def self.fetch(client,endpoint,shard,query_options)
      @uri      = assemble_uri(shard,endpoint)
      @headers  = assemble_headers(client)
      @query    = assemble_query(client,query_options)

      @response = client.class.get(@uri,{headers: @headers,
                                        query:    @query})

      return @response,@query
    end



    private
      def self.assemble_uri(shard,endpoint)
        if endpoint == 'status'
          uri = '/status'
        else
          uri = "/shards/#{shard}/#{endpoint}"
        end
        return uri
      end


      def self.assemble_headers(client)
        headers = { "Accept" => client.content_type }
        
        headers["Authorization"]    = client.api_key  if client.api_key
        headers["Accept-Encoding"]  = "gzip"          if client.gzip

        return headers
      end


      def self.assemble_query(client, query_options)
        query_options.each do |key,value|
          remove_spaces(value) if value
        end
        query = query_options
        
        return query
      end

      def self.remove_spaces(string)
        string.gsub!(/((?<=,)\s+)|(\s+(?=,))/,"") if string
      end
  end
end