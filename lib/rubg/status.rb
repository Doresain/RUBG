module RUBG
  class Status
    attr_reader :released_at, :version
    
    def initialize(client)
      response = client.class.get("/status")
      status = response.parsed_response

      @alive = ((response.response.class == Net::HTTPOK) ? true : false)
      @released_at = status["data"]["attributes"]["releasedAt"]
      @version = status["data"]["attributes"]["version"]
    end

    def alive?
      @alive ? true : false
    end
  end
end
