require 'httparty'

module RUBG
  class Client
    include HTTParty
    base_uri 'https://api.playbattlegrounds.com'
    format :json
    parser RUBG::JsonGzipParser
    attr_reader :gzip
    attr_accessor :api_key, :content_type

    def initialize( args={} )
      args          = self.class.defaults.merge(args)
      @api_key      = args[:api_key]
      @content_type = args[:content_type]
      @gzip         = args[:gzip]
    end


    def status( args={} )
      args = {:client => self }.merge(args)
      RUBG::Status.fetch(args)
    end


    def players( args )
      args = {:client => self }.merge(args)
      RUBG::PlayerCollection.fetch( args )
    end

  
    def player( args )
      args = {:client => self }.merge(args)
      RUBG::Player.fetch( args )
    end


    def matches

    end


    def match ( args )
      args = {:client => self }.merge(args)
      RUBG::Match.fetch( args )
    end


    def telemetry

    end


    private

    def self.defaults
      {
        :api_key      => ENV['PUBG_API_KEY'],
        :content_type => "application/vnd.api+json",
        :gzip         => true
      }
    end

  end
end