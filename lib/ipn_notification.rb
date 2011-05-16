module Paypal
  class IpnNotification
      
      def initialize
        @config = Paypal::Config.new
      end
      
      def send_back(data)
        data = "cmd=_notify-validate&#{data}"
        url = URI.parse @config.paypal_base_url
        http = Net::HTTP.new(url.host, 443)
        #http.use_ssl = true
        #http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        path = "#{@config.paypal_base_url}/cgi-bin/webscr"
        response_data = http.post(path, data)

        @verified = response_data == "VERIFIED"
      end
      
      def verified?
        @verified
      end
  end
end