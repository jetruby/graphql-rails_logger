require 'action_controller/log_subscriber'
require 'rouge'

module GraphQL
  module RailsLogger
    class Subscriber < ActionController::LogSubscriber
      def start_processing(event)
        return unless logger.info?

        payload = event.payload
        params  = payload[:params].except(*INTERNAL_PARAMS)
        format  = payload[:format]
        format  = format.to_s.upcase if format.is_a?(Symbol)

        info "Processing by #{payload[:controller]}##{payload[:action]} as #{format}"

        if Rails.application.config.graphql_logger.fetch(payload[:controller], []).include?(payload[:action])
          formatter = Rouge::Formatters::Terminal256.new
          query_lexer = Rouge::Lexers::GraphQL.new
          variables_lexer = Rouge::Lexers::Ruby.new

          (params['_json'] || [params.slice('query', 'variables')]).each do |data|
            query = data['query'].lines.map { |line| "  #{line}" }.join.chomp # add indentation
            variables = PP.pp(data['variables'] || {}, '')
            info "  Variables: #{formatter.format(variables_lexer.lex(variables))}"
            info formatter.format(query_lexer.lex(query))
          end
        else
          info "  Parameters: #{params.inspect}" unless params.empty?
        end
      end
    end
  end
end
