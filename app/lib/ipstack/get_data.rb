module Ipstack
  class GetData
    URL = 'http://api.ipstack.com/%<search_target>s'.freeze

    def call(search_target)
      @url = format(URL, search_target: search_target)
      @response = Faraday.get(url, access_key: ENV.fetch('IPSTACK_API_ACCESS_KEY', ''), output: :json)
      log_error_response(response) unless response.success?

      JSON.parse(response.body)
    rescue Faraday::Error => e
      Rails.logger.error("[ERROR] [#{Faraday.name}] url=#{url} message=#{e.message}")
    rescue JSON::ParserError => e
      Rails.logger.error("[ERROR] [#{self.class.name}] [#{JSON.name}] message=#{e.message}")
    rescue StandardError => e
      Rails.logger.error("[ERROR] [#{self.class.name}] url=#{url} message=#{e.message}")
    end

    private

    attr_reader :url, :response

    def log_error_response(response)
      Rails.logger.error("[ERROR] [#{self.class.name}] url=#{url} status=#{response.status} body=#{response.body}")
    end
  end
end
