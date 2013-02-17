module Opencnam
  module Util
    private

    def parse_response_date(date_string)
      DateTime.iso8601(date_string).to_time
    rescue ArgumentError
      nil
    end

    def process_response(response, name_only)
      if response.kind_of?(Net::HTTPOK)
        return { :name => response.body } if name_only

        # Parse JSON to Hash
        hash = JSON.parse(response.body, :symbolize_names => true)

        # Convert hash[:created] and hash[:updated] from String to Time
        hash.merge({ :created => parse_response_date(hash[:created]),
                     :updated => parse_response_date(hash[:updated]), })
      else
        raise OpencnamError.new response.message
      end
    end
  end
end
