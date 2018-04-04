module RUBG
  class Players
    attr_reader :errors, :data, :raw_response, :uri, :headers, :query


    def initialize(client, options)
      players = players_endpoint(client, options)

      @errors       = players["errors"]
      @data         = players["data"]
      @raw_response = players
    end


    private
      def players_endpoint(client, options)
        @uri    = assemble_uri(options)
        @headers = assemble_headers(client)
        if options["playerIds"] || options["playerNames"]
          @query   = assemble_query(client,options)
        else
          @query = ""
        end

        response = client.class.get(@uri,{headers: @headers,
                                        query:    @query})

        return response.parsed_response
      end


      def assemble_uri(options)
        shard = options["shard"] || "pc-na"
        uri = "/#{shard}/players"

        return uri
      end

      def assemble_headers(client)
        headers = {
                  "Authorization"   => client.api_key, 
                  "Accept"          => client.content_type
                }

        return headers
      end

      def assemble_query(client, options)
        query = {}
        query["filter[playerIds]"] = options["playerIds"].delete(' ') if options["playerIds"]
        query["filter[playerNames]"] = options["playerNames"].delete(' ') if options["playerNames"]
        
        return query
      end
  end
end


# response["data"][0]["relationships"]["matches"]["data"][0]["id"]