require 'minitest/spec'
require 'minitest/autorun'
require 'fakeweb'
require 'opencnam'

describe OpenCNAM do
  before do
    FakeWeb.allow_net_connect = false
  end

  it "strips all characters except the last 10 integers" do
    phone_numbers = [
      '7731231234',
      '17731231234',
      '+17731231234',
      '(773) 123-1234',
      '1 (773) 123-1234',
      '+1 (773) 123-1234',
      '1011417811111117731231234',
      '1 sajf@!#*& 773 () 123 $!f 1234',
      7731231234,
      17731231234,
    ]

    phone_numbers.each do |phone_number|
      OpenCNAM::Util.clean_phone_number(phone_number).must_equal '7731231234'
    end
  end

  it "raises an exception if parsing fails" do
    phone_numbers = [
      'adf43a2f78af1',
      '0987654',
      12345,
      'abcdef',
      '',
      nil,
    ]

    phone_numbers.each do |phone_number|
      lambda {
        OpenCNAM::Util.clean_phone_number(phone_number)
      }.must_raise OpenCNAM::InvalidPhoneNumberError
    end
  end

  it "returns a caller's name" do
    FakeWeb.register_uri(
      :get,
      %r|https://api.opencnam\.com/|,
      :status => ["200"],
      :body => 'VANN,NYSA',
    )

    res = OpenCNAM.lookup('7731234567')
    res[:name].must_equal 'VANN,NYSA'
    res[:number].must_equal '7731234567'
  end

  it "raises an exception if OpenCNAM is running a lookup" do
    FakeWeb.register_uri(
      :get,
      %r|https://api.opencnam\.com/|,
      :status => ["202"]
    )

    lambda {
      OpenCNAM.lookup('7731231234')
    }.must_raise OpenCNAM::RunningLookupError
  end

  it "raises an exception if request is bad (should not happen)" do
    FakeWeb.register_uri(
      :get,
      %r|https://api.opencnam\.com/|,
      :status => ["400"]
    )

    lambda {
      OpenCNAM.lookup('7731231234')
    }.must_raise OpenCNAM::BadRequestError
  end

  it "raises an exception if OpenCNAM has throttled requests" do
    FakeWeb.register_uri(
      :get,
      %r|https://api.opencnam\.com/|,
      :status => ["403"]
    )

    lambda {
      OpenCNAM.lookup('7731231234')
    }.must_raise OpenCNAM::ThrottledError
  end

  it "raises an exception if OpenCNAM has no caller information" do
    FakeWeb.register_uri(
      :get,
      %r|https://api.opencnam\.com/|,
      :status => ["404"]
    )

    lambda {
      OpenCNAM.lookup('7731231234')
    }.must_raise OpenCNAM::NoInfoError
  end

  it "raises an exception if OpenCNAM returns an unknown response" do
    FakeWeb.register_uri(
      :get,
      %r|https://api.opencnam\.com/|,
      :status => ["500"]
    )

    lambda {
      OpenCNAM.lookup('7731231234')
    }.must_raise OpenCNAM::OpenCNAMError
  end
end
