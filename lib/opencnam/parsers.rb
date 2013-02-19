module Opencnam
  module Parsers
    private

    def parse_iso_date_string(date_string)
      DateTime.iso8601(date_string).to_time
    rescue ArgumentError
      nil
    end

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
