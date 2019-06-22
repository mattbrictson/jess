# Jess

[![Gem Version](https://badge.fury.io/rb/jess.svg)](http://badge.fury.io/rb/jess)
[![Build Status](https://travis-ci.org/mattbrictson/jess.svg?branch=master)](https://travis-ci.org/mattbrictson/jess)
[![Code Climate](https://codeclimate.com/github/mattbrictson/jess/badges/gpa.svg)](https://codeclimate.com/github/mattbrictson/jess)
[![Coverage Status](https://coveralls.io/repos/github/mattbrictson/jess/badge.svg?branch=master)](https://coveralls.io/github/mattbrictson/jess?branch=master)

**Jess is an extremely lightweight, read-only client for the JAMF Software Server (JSS) API.**
This is a young project and is experimental. Currently it only provides access to computer and mobile device records.

Jess aims to be:

* Fast
* Easy to use
* Small (zero dependencies)
* Well-tested
* Multi-tenant friendly (connect to many JSS endpoints)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "jess"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jess

*Note that Jess requires Ruby 2.4 or newer.*

## Usage

First establish a connection.

```ruby
require "jess"

# Simple
conn = Jess.connect("https://jsshost", username: "user", password: "secret")

# Advanced, with more options available
http = Jess::HttpClient.new(
  "https://jsshost",
  username: "user",
  password: "secret",
  net_http_options: {
    keep_alive_timeout: 5,
    open_timeout: 5,
    read_timeout: 10,
    verify_mode: OpenSSL::SSL::VERIFY_NONE
  },
  logger: nil # disable default logging
)
conn = Jess::Connection.new(http)
```

Then retrieve a computer:

```ruby
computer = conn.computers.find(1234)
computer.id                 # => 1234
computer.name               # => "Matt's iMac"
computer.general.ip_address # => "10.0.0.17"
computer.hardware.model     # => "iMac Intel (Retina 5k, 27-Inch, Late 2015)"
```

Or a mobile device:

```ruby
phone = conn.mobile_devices.find(5678)
phone.id                    # => 5678
phone.general.serial_number # => "G15ER8WGSC61L"
```

In general, the objects provided by Jess mirror the structure of the JSON returned by the JSS API. The exception to this rule is `extension_attributes`, which for convenience are transformed into a Hash-like object for easy access:

```ruby
computer.extension_attributes.key?("My Ext Attr Name") # => true
computer.extension_attributes["My Ext Attr Name"]      # => "value"
```

If you ever need access to the raw JSON data of any object, use the `_json` method:

```ruby
computer.extension_attributes._json # => [{ ... }]
```

## Gotchas

Beware of these gotchas due to limitations of the JSS JSON API.

### Timestamps

Jess does not perform any type conversions. For example, timestamps are provided exactly as returned in the original JSON; they are not converted to Ruby DateTime objects.

```ruby
computer.purchasing.po_date_utc   # => "2016-03-18T00:00:00.000-0500"
computer.purchasing.po_date_epoch # => 1399698000000
```

### Unspecified values

JSS does a poor job of indicating unspecified values. For example, a computer where the bus speed cannot be determined will return `0` rather that `null` for the `bus_speed` JSON value. Likewise, unspecified string values are `""`, and unspecified timestamps are `""` or `0` instead of `null`. Jess passes these values straight through without any interpretation, so be aware that just because an attribute is *truthy* does not mean it has a useful value.

```ruby
# A computer without warranty information
computer.purchasing.warranty_expires       # => ""
computer.purchasing.warranty_expires_epoch # => 0
```

## Why not ruby-jss?

The [ruby-jss](http://pixaranimationstudios.github.io/ruby-jss/) gem is the most popular Ruby library for accessing the JSS API. Compared to Jess, ruby-jss has many more features, and is probably the more suitable solution for most use cases. So when might you use Jess instead?

* Jess offers a cleaner connection model that doesn't rely on global variables, which makes Jess easier to use if you need to connect to multiple JSS endpoints in the same Ruby process.
* Jess internally uses Ruby standard library Net::HTTP and supports persistent HTTP/1.1 connections; this may be faster than ruby-jss in some scenarios.

## Who uses Jess?

Jess powers [Robot Cloud Vision-Bot](http://www.robotcloud.net/dashboard/).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run the tests and RuboCop checks. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and other discussions are welcome on GitHub at <https://github.com/mattbrictson/jess>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Before opening a pull request, please read [CONTRIBUTING.md](CONTRIBUTING.md) for important coding guidelines and policies.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
