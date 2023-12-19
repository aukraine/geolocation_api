module Errors
  class MisdirectedRequest < Base
    def status_code  = 421
    def simple_error = 'The request was directed to a server that is not able to produce a response.'
  end
end
