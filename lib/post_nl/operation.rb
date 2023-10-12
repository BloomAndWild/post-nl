module PostNL
  class Operation
    include Errors

    attr_reader :response, :options, :http_client

    def initialize(http_client: default_http_client, **options)
      @options = options
      @http_client = http_client
    end

    def execute
      json_payload = JSON.generate(payload)

      @response = http_client.request(http_method: http_method, path: endpoint, payload: json_payload)
      body = JSON.parse(response.body, symbolize_names: true)

      handle_response_body(body)
    end

    protected

    def default_http_client
      PostNL::HttpClient.instance
    end

    def http_method
      raise NoMethodError, "subclass must implement #{__method__}"
    end

    def endpoint
      raise NoMethodError, "subclass must implement #{__method__}"
    end

    private

    def handle_response_body(body)
      body
    end

    def payload
      options[:payload]
    end

    def config
      Client.config
    end
  end
end
