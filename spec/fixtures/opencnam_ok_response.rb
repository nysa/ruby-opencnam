class OpencnamOkResponse < Net::HTTPOK
  def body
    '{ "uri": "/v2/phone/%2B16502530000", "price": 0, "updated": "2013-02-17T01:34:22.501327", "name": "GOOGLE INC", "created": "2012-10-12T06:53:05.194858", "number": "+16502530000"}'
  end

  def initialize
  end

  def message
    'OK'
  end
end
