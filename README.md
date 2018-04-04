# RUBG

RUBG is an unofficial Ruby PUBG API wrapper.

It is also a side project I am using to build my own Ruby skills. As such, updates may be slow and this gem may not remain up to date with API changes. Please feel free to leave enhancement requests as issues, I may use that to help prioritize. 

## Status

Development is very much in-progress.

#### Working:
- The /status endpoint is fully functional.
- The /players endpoint is partially functional. Queries may be performed, but the response is raw JSON only.

#### To-do
1. Finish /players endpoint, converting players to Player objects and matches to Match objects in response
2. Add /player endpoint to retrieve a single player
3. Add /matches endpoint to retrieve a single match, including objects for Rosters, etc.
4. Telemetry

At some point in there I need to get testing coverage up to date.

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

#### Create a Client
First, create a client and provide your API key:
```ruby
client = RUBG::Client.new("your-api-key-here")
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
/players is currently only partially functional. Queries may be performed, but the response is JSON only. You can obtain match IDs to look up manually, however, until I implement /matches.

.players requires an 'options' argument, which should be a hash containing:

- "shard" - Specify the [shard](https://documentation.playbattlegrounds.com/en/making-requests.html#regions) to retreieve data from. If none is specified, "pc-na" will be used as default.
- "playerNames" - Comma-separated list of players to search for. Names are case-sensitive.
- "playerIds" - Comma-separated list of player IDs to search for.

Note: If neither playerIds nor playerNames are included in options no results will be returned - at least one name or Id must be present.

```ruby
options = {"shard" => "pc-na", "playerNames" => "Shroud,JoshOG,PlayerUnknown"}
players = client.players(options)
```

The response will contain a top level object called 'errors' or 'data' depending on if the query failed or succeeded.

```ruby
players.errors .    # [{"title"=>"Not Found", "detail"=>"No players found matching criteria"}]
```

```ruby
players.data        # Returns retrieved player data.
```

## Contributing

Bug reports are welcome on GitHub at https://github.com/dor-edras/rubg. Given that I am using this as a teaching tool for myself I will not be accepting contributions for the time being - this may change in future. That said, feel free to fork the repository and update it yourself as you'd like.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

