module Paypal
  class Request
    def initialize
      @@settings ||= Paypal::Settings.new
      REQUESTS.each { |request| Request.define_request request }
    end
    
    def self.define_request(request)
      define_method(request[:name]) do |request_data|
        path = "/AdaptivePayments/#{request[:name].camelcase}"
        request_data = JSON.unparse(request_data)
        response_data = Paypal::HttpConnection.new.api_call(path, request_data, @@settings.headers)
        response_data = JSON.parse(response_data)
        return Paypal::RequestHash.new(response_data) if request[:request_hash]
        response_data
      end
    end
  end
end