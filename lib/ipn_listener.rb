module AdaptivePayments 
  class IpnListener

    def self.call(env)
      request = Rack::Request.new(env)
      #params = request.params
      #ipn = Paypal::Request.new
      #Paypal::Request.new.send_back(env['rack.request.form_vars'])
      #[200, {"Content-Type" => "text/html"}, [env['rack.request.query_hash'].to_s]]
      response = AdaptivePayments::Request.new.send_back(request.POST)
      [200, {}, [response]]
    end

  end 
end