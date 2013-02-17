module Opencnam
  module Util
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
  end
end
