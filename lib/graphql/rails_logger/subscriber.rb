require 'graphql/rails_logger/configuration'
require 'action_controller/log_subscriber'
require 'rouge'
require 'pp'

module GraphQL
  module RailsLogger
    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    class Subscriber < ActionController::LogSubscriber
      def start_processing(event)
        return unless logger.info?

        payload = event.payload
        params  = payload[:params].except(*INTERNAL_PARAMS)
        format  = payload[:format]
        format  = format.to_s.upcase if format.is_a?(Symbol)

        config = GraphQL::RailsLogger.configuration

        info "Processing by #{payload[:controller]}##{payload[:action]} as #{format}"

        if config.white_list.fetch(payload[:controller], []).include?(payload[:action])
          formatter = Rouge::Formatters::Terminal256.new(config.theme)
          query_lexer = Rouge::Lexers::GraphQL.new
          variables_lexer = Rouge::Lexers::Ruby.new

          (params['_json'] || [params.slice('query', 'variables', 'extensions')]).each do |data|

            next if config.skip_introspection_query && data['query'].index(/query IntrospectionQuery/)

            # Cleanup and indent params for logging
            query = indent(data.fetch('query', ''))
            variables = indent(pretty(data.fetch('variables', '')))
            extensions = indent(pretty(data.fetch('extensions', '')))

            info "\nVariables:\n#{formatter.format(variables_lexer.lex(variables))}" if variables.present?
            info "\nQuery:\n#{formatter.format(query_lexer.lex(query))}" if query.present?
            info "\nExtensions:\n#{formatter.format(variables_lexer.lex(extensions))}" if extensions.present?
          end
        else
          info "\nParameters:\n#{params.inspect}" unless params.empty?
        end
      end

      private

      def indent(data)
        data.lines.map { |line| "  #{line}" }.join.chomp
      end

      def pretty(data)
        return '' if data.blank?

        data = JSON.parse(data) if data.is_a?(String)
        PP.pp(data, '')
      end
    end
  end
end
