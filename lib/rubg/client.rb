require 'httparty'

module RUBG
  class Client
    include HTTParty
    base_uri 'https://api.playbattlegrounds.com/shards'
    attr_accessor :api_key, :content_type
    
    def initialize(api_key = ENV['PUBG_API_KEY'])
      @api_key = api_key
      @content_type = "application/vnd.api+json"
    end

    # options variable is a hash of:
    # "shard" - Specify the shard to retreieve data from. If none is specified pc-na will be used.
    # "playerNames" - Comma-separated list of players to search for, case-sensitive
    # "playerIds" - Comma-separated list of player IDs to search for.
    # Note that if neither playerIds or playerNames is included no results will be returned.
    def players(options)
      RUBG::Players.new(self, options)
    end
  end
end