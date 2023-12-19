module Ipstack
  class GetData
    URL = 'http://api.ipstack.com/%<search_target>s'.freeze

    def call(search_target)
      @url = format(URL, search_target: search_target)
      @response = Faraday.get(url, access_key: ENV.fetch('IPSTACK_API_ACCESS_KEY', ''), output: :json)
      log_error_response(response) unless response.success?

      response
    end

    private

    attr_reader :url, :response

    def log_error_response(response)
      Rails.logger.error("[ERROR] [#{self.class.name}] url=#{url} status=#{response.status} body=#{response.body}")
    end
  end
end
