require 'opencnam/parsers'

module Opencnam #:nodoc:
  # :nodoc:
  # @!attribute [rw] account_sid
  #   @return [String] the account_sid
  # @!attribute [rw] auth_token
  #   @return [String] the auth_token
  # @!attribute [w] use_ssl
  #   @return [Boolean]
  class Client
    # The OpenCNAM API hostname
    API_HOST = 'api.opencnam.com'
    include Parsers

    attr_writer :use_ssl
    attr_accessor :account_sid, :auth_token

    def initialize
      @account_sid = nil
      @auth_token = nil
      @use_ssl = false
    end

    # Returns true if this client instance is configured to use SSL by
    # default.
    #
    # @return [Boolean]
    def use_ssl?
      @use_ssl
    end

    # Look up a phone number and return the caller's name.
    #
    # @param [String] phone_number The phone number to look up
    # @param [Hash] options Described below
    # @option options [String] :account_sid Specify a different OpenCNAM
    #   account_sid
    # @option options [String] :auth_token Specify a different OpenCNAM
    #   auth_token
    # @option options [String, Symbol] :format The format to retrieve, can be
    #   :text or :json
    # @return [String, Hash] the phone number owner's name if :format is
    #   :string, or a Hash of additional fields from OpenCNAM if :format
    #   is :json (:created, :updated, :name, :price, :uri, and
    #   :number)
    def phone(phone_number, options = {})
      # Build query string
      options = {
        :account_sid => account_sid,
        :auth_token => auth_token,
        :format => 'text',
      }.merge(options)
      options[:format] = options[:format].to_s.strip.downcase

      # Check for supported format
      unless %w(text json).include? options[:format]
        raise ArgumentError.new "Unsupported format: #{options[:format]}"
      end

      # Send request
      http = Net::HTTP.new(API_HOST, (use_ssl? ? '443' : '80'))
      http.use_ssl = true if use_ssl?
      query = URI.encode_www_form(options)
      res = http.request_get("/v2/phone/#{phone_number.strip}?#{query}")

      # Look up was unsuccessful
      raise OpencnamError.new res.message unless res.kind_of? Net::HTTPOK

      return res.body if options[:format] == 'text'
      return parse_json(res.body) if options[:format] == 'json'
    end
  end
end
