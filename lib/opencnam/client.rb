require 'opencnam/util'

module Opencnam
  class Client
    extend Util

    attr_reader :api_base, :api_base_protocol
    attr_accessor :account_sid, :auth_token

    def initialize
      @api_base = 'api.opencnam.com'
      @api_base_protocol = 'http'
      @account_sid = nil
      @auth_token = nil
    end

    # Change the default protocol of this Client instance.
    def api_base_protocol=(protocol)
      @api_base_protocol = Opencnam::Client.sanitize_protocol(protocol)
    end

    # Look up a phone number and return the caller's name.
    def phone(phone_number, name_only = false)
      # Build query string
      query_hash = {
        :account_sid => self.account_sid,
        :auth_token => self.auth_token,
      }
      query_hash[:format] = 'json' unless name_only
      query = URI.encode_www_form(query_hash)

      # Send request
      uri = URI.parse("#{self.api_base_protocol}://#{self.api_base}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if self.api_base_protocol == 'https'

      res = http.request_get("/v2/phone/#{phone_number.strip}?#{query}")
      Opencnam::Client.process_response(res, name_only)
    end
  end
end
