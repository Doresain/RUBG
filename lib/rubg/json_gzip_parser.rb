module RUBG
  class JsonGzipParser < HTTParty::Parser
    def json
      resp = Zlib::GzipReader.new(StringIO.new(body)).read
      JSON.parse(resp, :quirks_mode => true, :allow_nan => true)
    end
  end
end