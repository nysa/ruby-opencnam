# ruby-opencnam

A Ruby wrapper for the [OpenCNAM](http://www.opencnam.com/) API service.

## Installation

Install from [RubyGems](http://rubygems.org/):

    $ gem install opencnam

Or include it in your `Gemfile` and install via Bundler's `bundle install`:

    gem 'opencnam', '~> 0.0.1'

## Usage

Using `ruby-opencnam` is easy. All you need to do is call `lookup` on the `OpenCNAM` module. You can pass any string or integer that represents a valid US phone number. `lookup` strips any non-integer character and will always use the last 10 digits. This means formats such as `'+1 (773) 123-4567'` will automatically resolve to `'7731234567'`. If the phone number happens to be less than 10 digits (and therefore not a valid US phone number), then OpenCNAM will raise an `OpenCNAM::InvalidPhoneNumberError`.

Simplest example:

    require 'opencnam'

    caller = OpenCNAM.lookup('7731234567')

    puts caller[:name]   # => 'VANN,NYSA'
    puts caller[:number] # => '7731234567'

## Notes

### Throttled requests
Beware, sending over 60 requests per hour to OpenCNAM's API without an API user and key will result in a 403 error and raise an `OpenCNAM::ThrottledError`. If you have an API user and key, you can configure `ruby-opencnam` to use them:

    OpenCNAM.api_user = 'your_opencnam_username'
    OpenCNAM.api_key  = 'your_opencnam_api_key'

### OpenCNAM::RunningLookupError
Sometimes you will send a request in which OpenCNAM does not yet have the caller's name. In this case, OpenCNAM's servers runs the lookup (in "typically 1 -> 3" seconds), and an `OpenCNAM::RunningLookupError` is raised. You can send the request again in a few seconds to retrieve the caller's name.

### Returned name formats
The name returned from OpenCNAM varies heavily, sometimes not providing a name at all and instead providing just a city and state such as `'SACRAMENTO CA'`. Sometimes names can get cut off, like `'VANN,NYS'`. Take caution if you plan on parsing names!

## License

Copyright &copy; 2012 Nysa Vann <<nysa@nysavann.com>>

ruby-opencnam is distributed under an MIT-style license. See LICENSE for details.
