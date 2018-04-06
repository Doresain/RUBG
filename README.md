# RUBG

RUBG is an unofficial Ruby PUBG API wrapper.

It is also a side project I am using to build my own Ruby skills. As such, updates may be slow and this gem may not remain up to date with API changes. Please feel free to leave enhancement requests as issues, I may use that to help prioritize. 

## Status

Development is very much in-progress. Note that breaking changes with new releases will be semi-frequent until initial development is complete (~1.0.0).

#### Working:
- The /status endpoint is fully functional.
- The /players endpoint is mostly functional. Queries may be performed, and player objects returned. Match data is ID strings only.

#### To-do
1. Finish /players endpoint, allowing conversion of matches to Match objects in response
2. Add /matches endpoint to retrieve a single match, including objects for Rosters, etc.
3. Telemetry
4. gzip support

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

Most methods take a hash as argument.

#### Create a Client
First, create a client and provide your API key:
```ruby
client = RUBG::Client.new({:api_key =>"your-api-key-here"})
```
    
The client object is used to make requests. If no key is added the gem will try and find it at ENV['PUBG_API_KEY'].

#### /status Endpoint

Check the PUBG API status and version:

```ruby
client.status.alive?         # true/false
client.status.version        # "v8.1.2"
client.status.released_at    # "2018-04-01T18:00:20Z"
```

#### /players Endpoint
/players is now mostly functional. Queries may be performed, and player objects returned. Match data is ID strings only, which you can use to look up manually until I implement /matches.

.players takes two arguments: :shard and :query_params 

:shard
- Specify the [shard](https://documentation.playbattlegrounds.com/en/making-requests.html#regions) to retreieve data from. If none is specified, "pc-na" will be used as default.

"query_params" - a hash containing any query options. For .players, the hash should contain *one* of the following options:
- "player_names" - Comma-separated list of players to search for. Names are case-sensitive.
- "player_ids" - Comma-separated list of player IDs to search for.

Note: If neither player_ids nor player_names are included in query_params no results will be returned - at least one name or Id must be present.

```ruby
args = {:shard => "pc-na", :query_params => {:player_names => "shroud,JoshOG,PlayerUnknown"}}
players = client.players(args)
```

The response will contain a top level object called 'errors' or 'data' and 'players', depending on if the query failed or succeeded.

```ruby
players.errors                    # [{"title"=>"Not Found", "detail"=>"No players found matching criteria"}]
```

```ruby
players.data                      # Returns retrieved player data.

players.players.first.name        #"shroud"
players.players.first.player_id   #"account.d50fdc18fcad49c691d38466bed6f8fd"
players.players.first.match_ids   #returns array of all match IDs for the player

players.response_ts            # Time object containing date/time of response
players.ratelimit              # Returns the max rate limit/min for your API key.
players.ratelimit_remaining    # Returns the number of requests your API key has remaining before hitting the ratelimit.

```

## Resources
[Offical PUBG API Documentation](https://documentation.playbattlegrounds.com/en/introduction.html)

[Official PUBG API Discord](https://discord.gg/FcsT7t3)

[Unofficial PUBG Developer Wiki](http://www.pubgwiki.org/Main_Page)


## Contributing

Bug reports are welcome on GitHub at https://github.com/dor-edras/rubg. Given that I am using this as a teaching tool for myself I will not be accepting contributions for the time being - this may change in future. That said, feel free to fork the repository and update it yourself as you'd like.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

