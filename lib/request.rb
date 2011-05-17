module Paypal
  class Request
    def initialize
      @settings = Paypal::Settings.new
      @env    = Rails.env
      REQUESTS.each { |request| Request.define_request request }
    end
    
    def self.define_request(request)
      define_method(request[:name]) do |request_data|
        path = "/AdaptivePayments/#{request[:name].camelcase}"
        request_data = JSON.unparse(request_data)
        response_data = Paypal::HttpConnection.new.api_call(path, request_data, @settings.headers)
        response_data = JSON.parse(response_data)
        return Paypal::RequestHash.new(response_data) if request[:request_hash]
        response_data
      end
    end
  end
  
  class RequestHash < Hash
    def initialize(response_data)
      @settings = Paypal::Settings.new
      COMMANDS.each { |command| RequestHash.define_command command }
      self.merge!(response_data)
    end
    
    def self.define_command(command)
      define_method("#{command[:name]}_url") do
        key_value = self["#{command[:key_name]}"] rescue nil
        return "#{@settings.paypal_base_url}/webscr?cmd=_ap-#{command[:name]}&#{command[:key_name].downcase}=#{key_value}" if key_value
        nil
      end
    end
    
    def success?
      self['responseEnvelope']['ack'] == 'Success'
    end
    
    def errors
      self['error'].inspect rescue nil
    end
  end
end