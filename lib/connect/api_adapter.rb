module Connect
  class ApiAdapter
    API_VERSION = "41.0".freeze

    class << self
      def describe(env=ENV)
        client(env).describe
      end

      def client(env=ENV)
        @client ||= Restforce.new(
          api_version:    API_VERSION,
          host:           env["SALESFORCE_REST_API_HOST"],
          client_id:      env["SALESFORCE_REST_API_CLIENT_ID"],
          client_secret:  env["SALESFORCE_REST_API_CLIENT_SECRET"],
          username:       env["SALESFORCE_REST_API_USERNAME"],
          password:       env["SALESFORCE_REST_API_PASSWORD"],
          security_token: env["SALESFORCE_REST_API_SECURITY_TOKEN"],
        )
      end
    end
  end
end
