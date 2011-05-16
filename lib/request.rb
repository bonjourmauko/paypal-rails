module Paypal
  class Request
    
    REQUESTS = [
        { :name => 'pay', :response => true },
        { :name => 'set_payment_options', :response => true },
        { :name => 'preapproval', :response => true },
        { :name => 'payment_details', :response => false },
        { :name => 'preapproval_details', :response => false },
        { :name => 'cancel_preapproval', :response => false },
        { :name => 'convert_currency', :response => false },
        { :name => 'refund', :response => false }
      ]
    
    def initialize
      @config = Paypal::Config.new
      @env    = Rails.env
      REQUESTS.each { |request| Request.define_request request }
    end
    
    def self.define_request(request)
      define_method(request[:name]) do |data|
        raise Exception unless data
        response_data = self.send("api_call", data, "/AdaptivePayments/#{request[:name].camelcase}")
        return Paypal::Response.new(response_data, @env) if request[:response]
        response_data
      end
    end
    
    def api_call(data, path)
      request_data = JSON.unparse(data)
      url = URI.parse @config.api_base_url
      http = Net::HTTP.new(url.host, 443)
      #http.use_ssl = false
      #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response_data = http.post(path, request_data, @config.headers)
      JSON.parse(response_data)
    end
    
    def success?
      self['responseEnvelope']['ack'] == 'Success'
    end
    
    def errors
      self['error'].inspect rescue nil
    end
    
  end
end