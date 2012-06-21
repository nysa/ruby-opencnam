require "net/http"

require "opencnam/version"
require "opencnam/util"
require "opencnam/errors/opencnam_error"
require "opencnam/errors/bad_request_error"
require "opencnam/errors/invalid_phone_number_error"
require "opencnam/errors/no_info_error"
require "opencnam/errors/running_lookup_error"
require "opencnam/errors/throttled_error"

module OpenCNAM
  @@api_base = 'https://api.opencnam.com'
  @@api_user = nil
  @@api_key  = nil

  def self.api_user=(api_user)
    @@api_user = api_user
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.lookup(number)
    # Clean phone number
    clean_number = OpenCNAM::Util.clean_phone_number(number)

    # Build query
    query = URI.encode_www_form(
      :format => 'text',
      :username => @@api_user,
      :api_key => @@api_key,
    )

    # Send request
    uri = URI.parse(@@api_base)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    res = http.request_get("/v1/phone/#{clean_number}?#{query}")

    # 200 - OK
    if res.kind_of?(Net::HTTPOK)
      return {
        :name => res.body,
        :number => clean_number,
      }
    end

    error_attrs = {
      :http_status => res.code,
      :message => res.message,
    }

    # 202 - Currently running a lookup for phone number
    if res.kind_of?(Net::HTTPAccepted)
      raise RunningLookupError.new(error_attrs)
    end

    # 403 - Forbidden, requests throttled
    if res.kind_of?(Net::HTTPForbidden)
      raise ThrottledError.new(error_attrs)
    end

    # 400 - Bad request
    if res.kind_of?(Net::HTTPBadRequest)
      raise BadRequestError.new(error_attrs)
    end

    # 404 - No caller ID name information
    if res.kind_of?(Net::HTTPNotFound)
      raise NoInfoError.new(error_attrs)
    end

    # Unkown response
    raise OpenCNAMError.new(error_attrs)
  end
end
