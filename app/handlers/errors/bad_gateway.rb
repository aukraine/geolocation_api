module Errors
  class BadGateway < Base
    def status_code  = 502
    def simple_error = 'The server, while acting as a gateway or proxy, received an invalid response.'
  end
end
