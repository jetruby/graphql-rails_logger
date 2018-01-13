module GraphQL
  module RailsLogger
    class Configuration
      attr_accessor :skip_introspection_query, :white_list

      def initialize
        @skip_introspection_query = nil

        # controller => [actions]
        @white_list = {
          'GraphqlController' => %w[execute]
        }
      end
    end
  end
end
