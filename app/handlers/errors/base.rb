require 'debug'

module Errors
  class Base < StandardError
    attr_reader :errors

    def initialize(*errors)
      @errors = errors.presence || [simple_error]
    end

    def to_json_api
      {
        errors: errors.map do |error|
          {
            status: status_code.to_s,
            title: simple_error,
            detail: error_detail(error),
          }
        end
      }
    end

    def error_detail(error)
      error.presence || simple_error
    end

    def status_code
      500
    end

    def detail_message(default)
      message == self.class.name ? default : message
    end

    def simple_error
      'An error has occurred on the backend.'
    end
  end
end
