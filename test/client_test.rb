require "test_helper"
include ClientTestSupport

class ClientTest < Minitest::Test

  def test_client_inherits_api_key_from_env
    ENV['PUBG_API_KEY'] = random_string
    client = PubgRuby::Client.new
    assert_equal ENV['PUBG_API_KEY'], client.api_key
    refute_empty client.api_key
  end

  def test_client_argument_overrides_api_key_from_env
    ENV['PUBG_API_KEY'] = random_string
    client = PubgRuby::Client.new(random_string)
    refute_equal ENV['PUBG_API_KEY'], client.api_key
    refute_empty client.api_key
  end

end