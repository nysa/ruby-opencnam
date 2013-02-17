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
      opts = {
        :account_sid => account_sid,
        :auth_token => auth_token,
        :format => 'text',
      }.merge(opts)
      opts[:format] = opts[:format].to_s.strip.downcase

      # Check for supported format
      unless %w(text json).include? opts[:format]
        raise ArgumentError.new "Unsupported format: #{opts[:format]}"
      end

      # Send request
      http = Net::HTTP.new(API_HOST, (use_ssl? ? '443' : '80'))
      http.use_ssl = true if use_ssl?
      query = URI.encode_www_form(opts)
      res = http.request_get("/v2/phone/#{phone_number.strip}?#{query}")

      # Look up was unsuccessful
      raise OpencnamError.new res.message unless res.kind_of? Net::HTTPOK

      return res.body if opts[:format] == 'text'
      return parse_json(res.body) if opts[:format] == 'json'
    end
  end
end
