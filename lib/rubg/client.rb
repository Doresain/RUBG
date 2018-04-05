require 'httparty'

module RUBG
  class Client
    include HTTParty
    base_uri 'https://api.playbattlegrounds.com'
    attr_accessor :api_key, :content_type, :gzip

    def initialize(api_key=ENV['PUBG_API_KEY'],gzip=false)
      @api_key = api_key
      @content_type = "application/vnd.api+json"
      @gzip = gzip
    end


    def status
      RUBG::Status.fetch(self)
    end


    def players(shard=$RUBG_DEFAULT_SHARD,query_options={})
      RUBG::Players.fetch(self, shard, query_options)
    end

  
    def player
    
    end


    def matches

    end


    def match

    end


    def telemetry

    end

  end
end