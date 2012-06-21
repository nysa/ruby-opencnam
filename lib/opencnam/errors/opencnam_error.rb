module OpenCNAM
  class OpenCNAMError < StandardError
    attr_reader :message
    attr_reader :http_status
    attr_reader :http_body

    def initialize(opts = {})
      @message = opts[:message] || nil
      @http_status = opts[:http_status] || nil
      @http_body = opts[:http_body] || nil
    end

    def to_s
      status = @http_status.nil? ? "" : "(Status #{@http_status}) "
      "#{status}#{@message}"
    end
  end
end
