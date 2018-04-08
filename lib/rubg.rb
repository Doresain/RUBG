require 'httparty'
require 'zlib'

require "rubg/json_gzip_parser"
require "rubg/version"
require "rubg/client"
require "rubg/rubg_endpoint"
require "rubg/player"
require "rubg/player_collection"
require "rubg/match"
require "rubg/match_collection"
require "rubg/roster"
require "rubg/participant"
require "rubg/telemetry"
require "rubg/status"


module RUBG
  $RUBG_DEFAULT_SHARD = ENV['RUBG_DEFAULT_SHARD'] || "pc-na"

  def self.new(args={})
    RUBG::Client.new(args)
  end

  # This doesn't serve a huge purpose, but is a reminder of the currently defined shards as published by Bluehole.
  # https://developer.playbattlegrounds.com/docs/en/making-requests.html#regions
  # Updated: 3/14/2018 @ 1:57PM EST
  def self.shards
    {
      "pc-na"     => "PC - North Amaerica",
      "pc-eu"     => "PC - Europe",
      "pc-krjp"   => "PC - Korea/Japan",
      "pc-oc"     => "PC - Oceania",
      "pc-kakao"  => "PC - Kakao",
      "pc-sea"    => "PC - South East Asia",
      "pc-sa"     => "PC - South America",
      "pc-as"     => "PC - Asia",
      "xbox-na"   => "XBOX - North America",
      "xbox-eu"   => "XBOX - Europe",
      "xbox-as"   => "XBOX - Asia",
      "xbox-oc"   => "XBOX - Oceania"
    }
  end

end
