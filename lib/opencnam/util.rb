module Opencnam
  module Util
    private

    def parse_response_date(date_string)
      DateTime.iso8601(date_string).to_time
    rescue ArgumentError
      nil
    end

    def process_response(resp, format)
      # Look up was unsuccessful
      raise OpencnamError.new resp.message unless resp.kind_of? Net::HTTPOK

      # Return body
      return resp.body if %w(text jsonp).include? format

      # Parse JSON to Hash
      hash = JSON.parse(resp.body, :symbolize_names => true)

      # Convert hash[:created] and hash[:updated] from String to Time
      hash.merge({ :created => parse_response_date(hash[:created]),
                   :updated => parse_response_date(hash[:updated]), })
    end

    def sanitize_and_convert_format(format)
      format = format.strip.downcase

      if %w(text html pbx).include? format
        return 'text'
      elsif %w(json xml yaml).include? format
        return 'json'
      elsif 'jsonp' == format
        return 'jsonp'
      else
        raise ArgumentError.new "Unsupported format type: #{format}"
      end
    end
  end
end
