module Paypal 
  class IpnListener
    def self.call(env)
      request = Rack::Request.new(env)
      params = request.params
      ipn = Paypal::IpnNotification.new
      ipn.send_back(env['rack.request.form_vars'])

      if ipn.verified?
        output = "Verified."
      else
        output = "Not Verified."
      end

      [200, {"Content-Type" => "text/html"}, [output]]
    end
  end 
end