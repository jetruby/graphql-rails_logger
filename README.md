# GraphQL::RailsLogger

## About
This gem allows you to inspect graphql queries in a more readable format.

This...

![screenshot_before](misc/screenshot_before.png)

becomes this ...

![screenshot_after](misc/screenshot_after.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-rails_logger'
```

And then execute:

    $ bundle

## Configuration

By default this gem formats params only for `GraphqlController#execute`.

If you want to change this behaviour, add `config/initializers/graphql_rails_logger.rb` file and set proper controller and actions like this:
```ruby
GraphQL::RailsLogger.configure do |config|
  config.white_list = {
    'QueriesController' => %w(create)
  }
end
```

There is an option to suppress (hide) the GraphQL Introspection Query from the console output. This may be helpful to declutter the console during client testing as these can be rather lengthy.

```ruby
GraphQL::RailsLogger.configure do |config|
  config.skip_introspection_query = true
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jetruby/graphql-rails_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GraphQL::RailsLogger project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jetruby/graphql-rails_logger/blob/master/CODE_OF_CONDUCT.md).

## About JetRuby

GraphQL::RailsLogger is maintained and founded by JetRuby Agency.

We love open source software!
See [our projects][portfolio] or
[contact us][contact] to design, develop, and grow your product.

[portfolio]: http://jetruby.com/portfolio/
[contact]: http://jetruby.com/#contactUs
