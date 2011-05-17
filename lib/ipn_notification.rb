module Paypal
  class IpnNotification
      def initialize
        @@settings ||= Paypal::Settings.new
      end
      
      def send_back(data)
        path = "#{@@settings.paypal_base_url}/cgi-bin/webscr"
        request_data = "cmd=_notify-validate&#{data}"
        Paypal::HttpConnection.new.paypal_call(path, request_data, nil)
        #@verified = response_data == "VERIFIED"
        #response_data
      end
      
      ## for db check
      #def verified?
      #  @verified
      #end
  end
end