module RUBG
  class Status < RubgEndpoint
    attr_reader :released_at, :version, :alive
    
    def initialize( args )
      args     = self.class.defaults.merge(args)

      @alive        = ((args[:response].response.class == Net::HTTPOK) ? true : false)
      @released_at  = Time.parse(args[:response]["data"]["attributes"]["releasedAt"])
      @version      = args[:response]["data"]["attributes"]["version"]
      super
    end


    def self.fetch( args )
      endpoint = "status"
      super({
        :client   => args[:client],
        :endpoint => endpoint
        })

      RUBG::Status.new({
        :client   => args[:client],
        :response => @response
        })
    end

    def alive?
      @alive ? true : false
    end


    private

      def self.defaults
        super
      end
  
  end
end
