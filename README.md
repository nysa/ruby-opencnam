# ruby-opencnam

A Ruby wrapper for the [OpenCNAM](http://www.opencnam.com/) API service.

ruby-opencnam v1.0.0 only supports OpenCNAM API v2. For more information see:
https://www.opencnam.com/docs/v2

## Installation

Install from [RubyGems](http://rubygems.org/):

    $ gem install opencnam

Or include it in your `Gemfile` and install via Bundler's `bundle install`:

    gem 'opencnam'

## Usage

Simplest example:

    require 'opencnam'

    client = Opencnam::Client.new

    client.phone('7731234567')
    # => 'VANN,NYSA'

    client.phone('7731234567', :format => :json)
    # => {:number=>"+17731234567", :uri=>"/v2/phone/%2B17731234567",
    #     :price=>0, :name=>"VANN,NYSA", :created=>2012-10-05 19:36:33 -0500,
    #     :updated=>2012-10-05 19:36:33 -0500}

## Notes

### Hobbyist Plan
Sending more than 60 requests within an hour without specifying a `account_sid` and `auth_token` will result in a 403 status code and raise an `Opencnam::OpencnamError`.

### Professional Plan
You can configure `ruby-opencnam` to use your `account_sid` and `auth_token`:

    client = Opencnam::Client.new(
      :account_sid => 'your_account_sid',
      :auth_token => 'your_auth_token',
    )

or

    client = Opencnam::Client.new
    client.account_sid = 'your_account_sid'
    client.auth_token = 'your_auth_token'

### SSL
You can send configure `ruby-opencnam` to send requests over SSL:

    client = Opencnam::Client.new(:use_ssl => true)

    # or

    client = Opencnam::Client.new
    client.use_ssl = true

    # Check if SSL is set
    client.use_ssl?
    # => true

### Opencnam::OpencnamError
Calling the `phone` method can raise an `Opencnam::OpencnamError` for a variety of reasons (not found, bad request, payment required, etc.). For a full list of things that can go wrong, see:
https://www.opencnam.com/docs/v2/apiref#cnam-status-codes

### Returned name formats
The name returned from OpenCNAM varies. Sometimes not providing a name at all and instead providing just a city and state such as `'SACRAMENTO CA'`. Sometimes names can get cut off, like `'VANN,NYS'`. Take caution if you plan on parsing names!

## License

Copyright &copy; 2013 Nysa Vann <<nysa@nysavann.com>>

ruby-opencnam is distributed under an MIT-style license. See LICENSE for details.
