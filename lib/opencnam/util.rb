module Opencnam
  module Util
    SUPPORTED_PROTOCOLS = %w(http https)

    def process_response(response, name_only)
      if response.kind_of?(Net::HTTPOK)
        return { :name => response.body } if name_only

        # Parse JSON to Hash
        hash = JSON.parse(response.body, :symbolize_names => true)

        # Convert hash[:created] and hash[:updated] from String to Time
        hash.merge({
          :created => DateTime.iso8601(hash[:created]).to_time,
          :updated => DateTime.iso8601(hash[:updated]).to_time,
        })
      else
        raise OpencnamError.new response.message
      end
    end

    # Converts protocol to string, stripped and downcased. Returns protocol
    # if protocol is supported.
    def sanitize_protocol(protocol)
      protocol = protocol.to_s.strip.downcase
      return protocol if SUPPORTED_PROTOCOLS.include?(protocol)
      raise ArgumentError.new "Only #{SUPPORTED_PROTOCOLS.join(', ')} allowed"
    end
  end
end
