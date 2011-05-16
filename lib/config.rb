module Paypal
  class Config
    
    attr_accessor :credentials,
                  :paypal_base_url,
                  :api_base_url,
                  :headers
    
    def initialize
      settings          = self.load File.join(Rails.root, 'config', 'paypal.yml')
      @env              = Rails.env
      @credentials      = settings['credentials'][@env]
      @paypal_base_url  = settings['base_url_mapping']['paypal'][@env]
      @api_base_url     = settings['base_url_mapping']['api'][@env]
      
      @headers = {
        "X-PAYPAL-SECURITY-USERID"      => @credentials['username'],
        "X-PAYPAL-SECURITY-PASSWORD"    => @credentials['password'],
        "X-PAYPAL-SECURITY-SIGNATURE"   => @credentials['signature'],
        "X-PAYPAL-APPLICATION-ID"       => @credentials['application_id'],
        "X-PAYPAL-REQUEST-DATA-FORMAT"  => "JSON",
        "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON"
      }
    end
    
    def load(file)
      settings = YAML.load_file file
      settings
    end
    
  end
end