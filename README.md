# pubg-rb

pubg-rb is an unofficial PUBG API wrapper for Ruby.

It is also a project I am using to build my own development skills. As such, it is likely this gem will not remain up to date with API changes, and updates will be slow. Given that I am using this as a teaching tool for myself I will not be accepting contributions. That said, feel free to use the gem as-is in your own application if it is useful, or to fork the repository and update it yourself as you'd like.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pubg_rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pubg_rb

## Usage

First, create a client and provide your API key:
    $ client = PubgRb::Client.new("your-api-key-here")
If no key is added the gem will try and find it at ENV['PUBG_API_KEY'].

Only the players endpoint is functional at present, and it is only partially functional:
    $ options = {"shard" => "pc-na", "playerNames" => "Shroud"}
    $ client.players(options)


options variable should be a hash of:
    # "shard" - Specify the shard to retreieve data from. If none is specified pc-na will be used.
    # "playerNames" - Comma-separated list of players to search for, case-sensitive
    # "playerIds" - Comma-separated list of player IDs to search for.
Note that if neither playerIds or playerNames are included no results will be returned.


## Contributing

Bug reports are welcome on GitHub at https://github.com/dor-edras/pubg_rb. As mentioned above, I am not accepting contributions to this project but you are welcome to fork it!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

