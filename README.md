# Jaly

Japanese Lyrics Reader.
It is the integration of lyrics services and keyword search engines.

## Installation

Install it yourself as:

    $ gem install jaly

## Usage

Read the lyrics from URI:

    $ jaly "http://YOUR-URI"

Or specify URI mode option:

    $ jaly -u "http://YOUR-URI"

[WIP] Search lyrics for your keywords:

    $ jaly "KEYWORDS"

[WIP] Or specify Search mode option:

    $ jaly -s "KEYWORDS"

[WIP] Execute interactive mode:

    $ jaly

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sabamotto/jaly.

