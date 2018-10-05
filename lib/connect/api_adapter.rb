# frozen_string_literal: true
require 'restforce'

module Connect
  class ApiAdapter

    class << self
      def describe(env=ENV)
        client(env).describe
      end

      def client(env=ENV)
        @client ||= Restforce.new(
          api_version:    env.fetch('API_VERSION', "41.0"),
          host:           env.fetch("SALESFORCE_REST_API_HOST"),
          client_id:      env.fetch("SALESFORCE_REST_API_CLIENT_ID"),
          client_secret:  env.fetch("SALESFORCE_REST_API_CLIENT_SECRET"),
          username:       env.fetch("SALESFORCE_REST_API_USERNAME"),
          password:       env.fetch("SALESFORCE_REST_API_PASSWORD"),
          security_token: env.fetch("SALESFORCE_REST_API_SECURITY_TOKEN"),
        )
      end
    end
  end
end
