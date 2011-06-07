module AdaptivePayments
  class Transaction < AdaptivePayments::Base
    attr_accessor :response
    
    def initialize
      super unless defined? @@headers
      REQUESTS.each { |request| Transaction.define_request request }
      COMMANDS.each { |command| Transaction.define_command command }
    end
    
    def self.define_request(request)
      define_method(request) do |request_data|
        path = "/AdaptivePayments/#{request.camelcase}"
        request_data = request_data.to_json
        response = api_call(path, request_data, @@headers)
        @response = JSON.parse(response)
      end
    end
    
    def self.define_command(command)
      define_method("#{command[:name]}_url") do
        key_value = @response["#{command[:key_name]}"] rescue nil
        return "#{@paypal_base_url}/webscr?cmd=_ap-#{command[:name]}&#{command[:key_name].downcase}=#{key_value}" if key_value
        nil
      end
    end
    
    def success?
      @response['responseEnvelope']['ack'] == 'Success'
    end
    
    def errors
      @response['error']
    end
  end
end
