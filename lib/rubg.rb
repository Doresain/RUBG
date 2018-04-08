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
end
