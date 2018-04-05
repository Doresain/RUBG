module RUBG
  class Status < RubgEndpoint
    attr_reader :released_at, :version
    
    def initialize(client,response)
      @alive = ((response.response.class == Net::HTTPOK) ? true : false)
      @released_at = Time.parse(response["data"]["attributes"]["releasedAt"])
      @version = response["data"]["attributes"]["version"]
      super
    end


    def self.fetch(client)
      endpoint = "status"
      super(client,endpoint)

      RUBG::Status.new(client, @response)
    end

    def alive?
      @alive ? true : false
    end
  end
end
