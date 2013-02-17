require 'opencnam/util'

module Opencnam
  class Client
    API_HOST = 'api.opencnam.com'
    include Util

    attr_writer :use_ssl
    attr_accessor :account_sid, :auth_token

    def initialize
      @account_sid = nil
      @auth_token = nil
      @use_ssl = false
    end

    def use_ssl?
      @use_ssl
    end

    # Look up a phone number and return the caller's name.
    def phone(phone_number, opts = {})
      # Build query string
      query_hash = {
        :account_sid => account_sid,
        :auth_token => auth_token,
        :format => 'text',
      }.merge(opts)
      query_hash[:format] = sanitize_and_convert_format(query_hash[:format])
      query = URI.encode_www_form(query_hash)

      # Send request
      http = Net::HTTP.new(API_HOST, (use_ssl? ? '443' : '80'))
      http.use_ssl = true if use_ssl?

      res = http.request_get("/v2/phone/#{phone_number.strip}?#{query}")
      process_response(res, query_hash[:format])
    end
  end
end
