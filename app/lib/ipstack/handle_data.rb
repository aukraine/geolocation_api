module Ipstack
  class HandleData
    PERSISTED_ATTRS = [:ip, :type, :latitude, :longitude, :location].freeze
    EXPECTED_FAILURE_RESPONSE = { detail: 'Not Found' }.freeze

    attr_reader :input, :output, :parsed_data

    def initialize(input)
      @input = input
      @output = {}
    end

    def transform
      parse_data
      validate_data
      transform_data

      output
    end

    private

    def parse_data
      @parsed_data = JSON.parse(input.body, symbolize_names: true)
    end

    def validate_data
      raise Errors::MisdirectedRequest, 'Not success response from external service' unless input.success?

      # we have to explicitly compare with False as response might not contain current property.
      raise Errors::MisdirectedRequest, parsed_data.dig(:error, :info) if parsed_data[:success] == false

      if parsed_data == EXPECTED_FAILURE_RESPONSE
        raise Errors::MisdirectedRequest, 'External service could not process URL with any prefixes'
      end
    end

    def transform_data
      output.merge! **parsed_data.slice(*PERSISTED_ATTRS)
      parsed_data[:location]&.merge! **parsed_data.except(*PERSISTED_ATTRS)
    end
  end
end
