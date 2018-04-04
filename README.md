# pubg-rb

pubg-rb is an unofficial PUBG API wrapper for Ruby.

It is also a project I am using to build my own development skills. As such, it is likely this gem will not remain up to date with API changes, and updates will be slow. Given that I am using this as a teaching tool for myself I will not be accepting contributions. That said, feel free to use the gem as-is in your own application if it is useful, or to fork the gem and update it yourself if you'd like.

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

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pubg_rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).




response["data"][0]["relationships"]["matches"]["data"][0]["id"]
response = client.class.get("/pc-na/players", {headers: {"Authorization" => "#{client.api_key}", "Accept" => "application/vnd.api+json"}, query: {"filter[playerNames]" => "Doresain"}})