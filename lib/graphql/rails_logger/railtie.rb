require 'graphql/rails_logger/subscriber'

module GraphQL
  module RailsLogger
    class Railtie < Rails::Railtie
      # Allowed controllers and actions
      config.graphql_logger = {
        'GraphqlController' => %w[execute]
      }

      initializer 'graphql.unsubscribe_default_logger' do
        ActiveSupport::Notifications.unsubscribe 'start_processing.action_controller'
        Subscriber.attach_to :action_controller
      end
    end
  end
end
