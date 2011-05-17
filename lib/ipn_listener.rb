module Paypal 
  class IpnListener

    def self.call(env)
      request = Rack::Request.new(env)
      params = request.params
      ipn = Paypal::Request.new
      response = ipn.send_back(env['rack.request.form_vars'])
      [200, {"Content-Type" => "text/html"}, [""]]
    end

  end 
end