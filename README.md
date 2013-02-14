# Yoolinkpro Ruby SDK

Ruby Gem for [YoolinkPro API](https://api.yoolinkpro.com) - [YoolinkPro](https://www.yoolinkpro.com)

Manage your feed, users, groups, teams... was never so easy!

## Installation

Add this line to your application's Gemfile:

    gem 'yoolinkpro-ruby-sdk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yoolinkpro-ruby-sdk

## Usage

* Instantiate a happy client

      client = Yoolinkpro::Client.new 'public_key', 'private_key', 'admin_key'

* Retrieve user, team, group by id...

      client.find :user, 1
      client.find :group, 1

* Search user by email

      client.search :user, email: "vincent@foo.io"

* Retrieve users, teams, groups...

      client.find_all :users
      client.find_all :groups

* Create a shiny new user, team, group

      client.create :user, { lastname: "Durand", firstname: "Vincent", email: "vincent@foo.io" }
      client.create :group, { name: "Api", description: "YoolinkPro Api", category: "Yoolinkpro" }

* Update our previous user

      client.update :user, 1, { firstname: "John" }

## Configuration for Ruby on Rails

add config/initializers/load_yoolinkpro.rb

    Yoolinkpro.configure do |config|
      config.public_key  = 'public_key'
      config.private_key = 'private_key'
      config.admin_key   = 'admin_key'
    end

    yp_api = Yoolinkpro::Client.new

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
