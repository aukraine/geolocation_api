module Ipstack
  class HandleData
    PERSISTED_ATTRS = [:ip, :type, :latitude, :longitude, :location].freeze

    attr_reader :input, :output

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
      @input = JSON.parse(input.body, symbolize_names: true)
    end

    def validate_data
      # we have to explicitly compare with False as response might not contain current property.
      raise Errors::MisdirectedRequest, input.dig(:error, :info) if input[:success] == false
    end

    def transform_data
      output.merge! **input.slice(*PERSISTED_ATTRS)
      input[:location].merge! **input.except(*PERSISTED_ATTRS)
    end
  end
end
