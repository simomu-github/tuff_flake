# TuffFlake

TuffFlake is a distributed unique ID generator like Snowflake

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'tuff_flake', github: 'simomu-github/tuff_flake'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install specific_install
    $ gem specific_install -l 'git://github.com/simomu-github/tuff_flake.git'

# Usage

```ruby
TuffFlake.setup(start_at: Time.parse('2018-04-01 00:00:00'), machine_id: 1)
TuffFlake.id
```
