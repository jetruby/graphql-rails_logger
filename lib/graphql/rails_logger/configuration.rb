require 'rouge'

module GraphQL
  module RailsLogger
    class Configuration
      attr_accessor :skip_introspection_query, :white_list, :theme

      def initialize
        @skip_introspection_query = nil

        # controller => [actions]
        @white_list = {
          'GraphqlController' => %w[execute]
        }

        @theme = Rouge::Themes::ThankfulEyes.new
      end
    end
  end
end
