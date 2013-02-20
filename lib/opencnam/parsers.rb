module Opencnam #:nodoc:
  # Contains utility methods for parsing responses from OpenCNAM.
  module Parsers
    private

    # Parses an ISO 8601 formatted date string.
    # @param [String] date_string
    # @return [Time]
    def parse_iso_date_string(date_string)
      DateTime.iso8601(date_string).to_time
    rescue ArgumentError
      nil
    end

    # Parses a JSON string.
    # @param [String] json the JSON formatted string
    # @return [Hash]
    def parse_json(json)
      hash = JSON.parse(json, :symbolize_names => true)

      # Convert hash[:created] and hash[:updated] to Time objects
      if hash[:created]
        hash.merge({ :created => parse_iso_date_string(hash[:created]) })
      end

      if hash[:updated]
        hash.merge({ :updated => parse_iso_date_string(hash[:updated]) })
      end

      hash
    end
  end
end
