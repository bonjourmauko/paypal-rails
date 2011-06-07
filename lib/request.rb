module AdaptivePayments
  class Request
    attr_accessor :response
    
    def initialize
      @@settings ||= AdaptivePayments::Base.new
      REQUESTS.each { |request| Request.define_request request }
      COMMANDS.each { |command| Request.define_command command }
    end
    
    def self.define_request(request)
      define_method(request) do |request_data|
        path = "/AdaptivePayments/#{request.camelcase}"
        request_data = request_data.to_json
        response = AdaptivePayments::HttpConnection.new.api_call(path, request_data, @@settings.headers)
        @response = JSON.parse(response)
      end
    end
    
    def self.define_command(command)
      define_method("#{command[:name]}_url") do
        key_value = @response["#{command[:key_name]}"] rescue nil
        return "#{@@settings.paypal_base_url}/webscr?cmd=_ap-#{command[:name]}&#{command[:key_name].downcase}=#{key_value}" if key_value
        nil
      end
    end
    
    def send_back(data)
      path = "#{@@settings.paypal_base_url}/cgi-bin/webscr"
      request_data = "cmd=_notify-validate&#{data}"
      AdaptivePayments::HttpConnection.new.paypal_call(path, request_data, nil)
    end
  end
end
