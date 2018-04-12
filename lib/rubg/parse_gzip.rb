module RUBG
  class ParseGzip < HTTParty::Parser
    SupportedFormats.merge!({"application/gzip" => :gzip})

    protected

    def gzip
      resp = Zlib::GzipReader.new(StringIO.new(body)).read
      JSON.parse(resp, :quirks_mode => true, :allow_nan => true)
    end
  end
end