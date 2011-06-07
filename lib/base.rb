module AdaptivePayments
  class Base
    attr_accessor :credentials,
                  :headers
    
    def initialize
      settings      = self.load File.join(Rails.root, 'config', 'paypal.yml')
      @env          = Rails.env
      @credentials  = settings['credentials'][@env]
      
      BASE_MAPPINGS.each do |name| 
        key   = "#{name}_base_url"
        value = settings['base_url_mapping'][name][@env]
        instance_variable_set("@#{key}", "#{value}") 
        Base.define_accessor(key, value)
      end
        
      @headers = {
        "X-PAYPAL-SECURITY-USERID"      => @credentials['username'],
        "X-PAYPAL-SECURITY-PASSWORD"    => @credentials['password'],
        "X-PAYPAL-SECURITY-SIGNATURE"   => @credentials['signature'],
        "X-PAYPAL-APPLICATION-ID"       => @credentials['application_id'],
        "X-PAYPAL-REQUEST-DATA-FORMAT"  => "JSON",
        "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON"
      }
    end
    
    def self.define_accessor(key, value)
      define_method(key) { value }
    end
    
    def load(file)
      YAML.load_file file
    end
  end
end