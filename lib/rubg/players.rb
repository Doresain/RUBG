module RUBG 
  class Players < RubgEndpoint

    def initialize(client,response)
      super
    end


    def self.fetch(client,shard,query_options)
      endpoint = "players"
      query_options["filter[playerNames]"] = query_options.delete("playerNames")
      query_options["filter[playerIds]"] = query_options.delete("playerIds")
      super(client,endpoint,shard,query_options)

      RUBG::Players.new(client,@response)
    end

  end
end


# response["data"][0]["relationships"]["matches"]["data"][0]["id"]