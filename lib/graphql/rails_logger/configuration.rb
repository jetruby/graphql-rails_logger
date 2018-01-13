module GraphQL
  module RailsLogger
    class Configuration
      attr_accessor :skip_introspection_query
      def initialize
        @skip_introspection_query = nil
      end
    end
  end
end
