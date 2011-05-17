module Paypal 
  class IpnListener
    def self.call(env)
      request = Rack::Request.new(env)
      params = request.params
      ipn = Paypal::IpnNotification.new
      response = ipn.send_back(env['rack.request.form_vars'])
      
      ## for db check
      #if ipn.verified?
      #  output = "Verified."
      #else
      #  output = "Not Verified."
      #end

      [200, {"Content-Type" => "text/html"}, [""]]
    end
  end 
end