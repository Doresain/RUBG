# RUBG

RUBG is an unofficial Ruby PUBG API wrapper.

RUBG attempts to be fairly comprehensive and provide abstraction from the PUBG API while remaining consistent enough that the [offical PUBG API documentation](https://documentation.playbattlegrounds.com/en/introduction.html) is still useful.



## Status

Development is very much in-progress. Note that breaking changes with new releases will be semi-frequent until initial development is complete (~1.0.0).

#### Working:
- The /status endpoint is fully functional.
- The /players endpoint is mostly functional. Queries may be performed, and player objects returned.
- The /matches endpoint is fully funtional. Match, roster, and participant data and stats are available with getter methods.

#### To-do
1. Telemetry
2. cross-object lookup convenience methods (ie. player.matches.fetch_latest or similar)

At some point in there I need to get testing coverage up to date.

*Note: xbox shards may not work correctly - only pc is currently tested. If you encounter issues pulling data from Xbox shards please log an issue and I will address.*



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubg



## Usage

### API Lookups

Most lookup methods take a hash as argument.


#### Base Class

```ruby
RUBG.new        # Convenience alias for RUBG::Client.new
RUBG.shards     # Reference for available PUBG platform/region shards
```

#### Create a Client
First, create a client and provide your API key:
```ruby
client = RUBG::Client.new({:api_key =>"your-api-key-here"})
```
    
The client object is used to make requests. If no key is added the gem will try and find it at ENV['PUBG_API_KEY'].

All responses are gzip that is parsed to json on receipt for faster transmission. At this timne this is not configurable, but should be transparent.

The response will contain either a top level object called 'errors' if unsuccessful.

```ruby
response.errors      # [{"title"=>"Not Found", "detail"=>"No players found matching criteria"}]
```


#### /status Endpoint

Check the PUBG API status and version:

```ruby
client.status.alive?         # true/false
client.status.version        # "v8.1.2"
client.status.released_at    # "2018-04-01T18:00:20Z"
```


#### /players Endpoint

.players takes two arguments: :shard and :query_params 

:shard
- Specify the [shard](https://documentation.playbattlegrounds.com/en/making-requests.html#regions) to retreieve data from. If none is specified, "pc-na" will be used as default.

:query_params - a hash containing any query options. For .players, the hash should contain *one* of the following options:
- :player_names - Comma-separated list of players to search for. Names are case-sensitive.
- :player_ids - Comma-separated list of player IDs to search for.

Note: If neither player_ids nor player_names are included in query_params no results will be returned - at least one name or Id must be present. The maximum in one request is currently 6.

```ruby
args = {:shard => "pc-na", :query_params => {:player_names => "shroud,JoshOG,PlayerUnknown"}}
response = client.players(args)
response.players     # collection of player objects

response.response_ts            # Time object containing date/time of response
response.ratelimit              # Returns the max rate limit/min for your API key.
response.ratelimit_remaining    # Returns the number of requests your API key has remaining before hitting the ratelimit.
response.ratelimit_reset        # Timestamp of ratelimit reset as Integer (Epoch seconds).
response.ratelimit_reset_in     # Seconds until ratelimit reset.
```


#### /players/{:id} Endpoint

.player is similar to .players, but looks up only a single player by player_id only.

:shard
- Specify the [shard](https://documentation.playbattlegrounds.com/en/making-requests.html#regions) to retreieve data from. If none is specified, "pc-na" will be used as default.

:query_params - a hash containing any query options. For .player, the hash must contain:
- :player_id - Player ID to search for.

```ruby
args = {:shard => "pc-na", :query_params => {:player_id => "shroud"}}
response = client.player(args)

response.response_ts            # Time object containing date/time of response
response.ratelimit              # Returns the max rate limit/min for your API key.
response.ratelimit_remaining    # Returns the number of requests your API key has remaining before hitting the ratelimit.
response.ratelimit_reset        # Timestamp of ratelimit reset as Integer (Epoch seconds).
response.ratelimit_reset_in     # Seconds until ratelimit reset.
```


#### /matches/{:id} Endpoint

.match looks up a single match by match_id only.

:shard
- Specify the [shard](https://documentation.playbattlegrounds.com/en/making-requests.html#regions) to retreieve data from. If none is specified, "pc-na" will be used as default.

:query_params - a hash containing any query options. For .match, the hash must contain:
- :match_id - Player ID to search for.

```ruby
args = {:shard => "pc-na", :query_params => {:match_id => "match-id-here"}}
response = client.match(args)

response.response_ts            # Time object containing date/time of response
response.ratelimit              # Returns the max rate limit/min for your API key.
response.ratelimit_remaining    # Returns the number of requests your API key has remaining before hitting the ratelimit.
response.ratelimit_reset        # Timestamp of ratelimit reset as Integer (Epoch seconds).
response.ratelimit_reset_in     # Seconds until ratelimit reset.

```



### RUBG Classes

#### RUBG::Player

Retrieved from .players or .player.

```ruby
player.first.name        #"shroud"
player.first.player_id   #"account.d50fdc18fcad49c691d38466bed6f8fd"
player.first.match_ids   # returns array of all match IDs for the player in the last 14 days
player.shard             # Shard the player was retrieved from
player.stats             # Not currently in use
```


#### RUBG::Match

Retrieved from .match.

```ruby
match.match_id                      # Unique match ID
match.created                       # Match creation time
match.duration                      # Match duration in seconds
match.mode                          # Match gamemode ("squad-fpp", "tequilafpp")
match.map                           # Miramar or Erangel
match.shard                         # Shard the match was played on
match.stats                         # Not currently in use
match.telemetry_id                  # ID for match telemetry file
match.telemetry_link                # Link to match telemetry file

match.participants                  # Collection of RUBG::Participant objects for all participants in the match.
match.rosters                       # Collection of RUBG::Response objects for all rosters in the match.
match.winners                       # Retrieves the RUBG::Roster object for the winning team.

match.player_count                  # Count of players in the match.
match.roster_count                  # Count of teams in the match.
match.names                         # List of names for all players in the match.
match.survived                      # Collection of RUBG::Participant objects for players alive at the end.
match.dbnos                         # Total non-lethal knockdowns. (down but not outs) Alias: .knocks
match.assists                       # Total assists.
match.boosts                        # Total boosts used.
match.damage_dealt                  # Total damage dealt.
match.damage_dealt_avg              # Avg damage dealt per player.
match.headshot_kills                # Total headshot kills.
match.heals                         # Total heals used.
match.kills                         # Total kills by players.
match.ride_distance_avg             # Avg distance traveled in vehicle per player.
match.revives                       # Total revives from downed state.
match.road_kills                    # Total road kills.
match.team_kills                    # Total team kills.
match.time_survived_avg             # Avg time survived per player in seconds.
match.vehicle_destroys              # Total vehicle destroys.
match.walk_distance_avg             # Avg walk distance per player.
match.weapons_acquired              # Total weapons acquired. Always 0 at present.
```


#### RUBG::Roster

Retrieved from .match and available in .rosters method. Not available as an independent resource.

```ruby
match.rosters[0].roster_id                     # Unique roster ID
match.rosters[0].shard                         # Shard the match was played on
match.rosters[0].team_id                       # Randomly assigned integer identifying the roster during the match.
match.rosters[0].rank                          # Roster placement at end of match.
match.rosters[0].won                           # true/false
match.rosters[0].size                          # Count of participants in roster.

match.rosters[0].participants                  # Collection of RUBG::Participant objects for roster members.

match.rosters[0].names                         # List of names for all players on the roster.
match.rosters[0].survived                      # Collection of RUBG::Participant objects roster members alive at the end.
match.rosters[0].dbnos                         # Total non-lethal knockdowns. (down but not outs) Alias: .knocks
match.rosters[0].assists                       # Total assists by roster.
match.rosters[0].boosts                        # Total boosts used by roster.
match.rosters[0].damage_dealt                  # Total damage dealt by roster.
match.rosters[0].damage_dealt_avg              # Avg damage dealt per player.
match.rosters[0].headshot_kills                # Total headshot kills by roster.
match.rosters[0].heals                         # Total heals used by roster.
match.rosters[0].kills                         # Total kills by roster.
match.rosters[0].ride_distance                 # Total distance traveled in vehicle by roster.
match.rosters[0].ride_distance_avg             # Avg distance traveled in vehicle per player.
match.rosters[0].revives                       # Total teammate revives from downed state by roster.
match.rosters[0].road_kills                    # Total road kills by roster.
match.rosters[0].team_kills                    # Total team kills by roster.
match.rosters[0].time_survived                 # Total time survived by roster in seconds.
match.rosters[0].time_survived_avg             # Avg time survived per player in seconds.
match.rosters[0].vehicle_destroys              # Total vehicle destroys by roster.
match.rosters[0].walk_distance                 # Total walk distance by roster.
match.rosters[0].walk_distance_avg             # Avg walk distance by roster per player.
match.rosters[0].weapons_acquired              # Total weapons acquired by roster. Always 0 at present.
```


#### RUBG::Participant

Retrieved from .match and available in .participants or .rosters[].participants methods. Not available as an independent resource. Match-specific stats for a player.

```ruby
match.participants[0].participant_id                # Unique participant ID
match.participants[0].shard                         # Shard the match was played on

match.participants[0].dbnos                         # Total non-lethal knockdowns. (down but not outs) Alias: .knocks
match.participants[0].assists                       # Total assists by participant.
match.participants[0].boosts                        # Total boosts used by participant.
match.participants[0].damage_dealt                  # Total damage dealt by participant.
match.participants[0].damage_dealt                  # Total damage dealt by participant.
match.participants[0].headshot_kills                # Total headshot kills by participant.
match.participants[0].heals                         # Total heals used by participant.
match.participants[0].kill_placement                # Kill placement vs other platers.
match.participants[0].kill_streaks                  # Total kill streaks by participant.
match.participants[0].kills                         # Total kills by participant.
match.participants[0].longest_kill                  # Distance of longest kill by player.
match.participants[0].most damage                   # Always seems to be 0, unknown.
match.participants[0].name                          # Participant name.
match.participants[0].player_id                     # Unique player ID for participant.
match.participants[0].revives                       # Total teammate revives from downed state by participant.
match.participants[0].ride_distance                 # Total distance traveled in vehicle by roster.
match.participants[0].road_kills                    # Total road kills by roster.
match.participants[0].team_kills                    # Total team kills by roster.
match.participants[0].time_survived                 # Total time survived by roster in seconds.
match.participants[0].vehicle_destroys              # Total vehicle destroys by roster.
match.participants[0].walk_distance                 # Total walk distance by roster.
match.participants[0].weapons_acquired              # Total weapons acquired by roster. Always 0 at present.

match.participants[0].kill_ranking_before...........# Kill ranking before match.
match.participants[0].kill_ranking_gained...........# Kill ranking gain or loss.
match.participants[0].win_ranking_before........... # Win ranking before match.
match.participants[0].win_ranking_gained........... # Win ranking gain or loss.
match.participants[0].overall_ranking_gained........# Overall ranking gained.

```



## Resources
[Offical PUBG API Documentation](https://documentation.playbattlegrounds.com/en/introduction.html)

[Official PUBG API Developer Resources](https://github.com/pubg/api-assets)

[Official PUBG API Discord](https://discord.gg/FcsT7t3)

[Unofficial PUBG Developer Wiki](http://www.pubgwiki.org/Main_Page)



## Contributing

Bug reports are welcome on GitHub at https://github.com/dor-edras/rubg. Given that I am using this as a teaching tool for myself I will not be accepting contributions for the time being - this may change in future. That said, feel free to fork the repository and update it yourself as you'd like.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).