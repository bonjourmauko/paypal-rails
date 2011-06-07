module AdaptivePayments
  class Base
    def initialize
      @@settings    ||= self.load File.join(Rails.root, 'config', 'paypal.yml')
      @@env         ||= Rails.env
      @@credentials ||= @@settings['credentials'][@@env]
      
      BASE_MAPPINGS.each do |name| 
        base_url = @@settings['base_url_mapping'][name][@@env]
        instance_variable_set("@#{name}_base_url", "#{base_url}") 
        Base.define_call("#{name}_call", base_url)
      end
        
      @@headers = {
        "X-PAYPAL-SECURITY-USERID"      => @@credentials['username'],
        "X-PAYPAL-SECURITY-PASSWORD"    => @@credentials['password'],
        "X-PAYPAL-SECURITY-SIGNATURE"   => @@credentials['signature'],
        "X-PAYPAL-APPLICATION-ID"       => @@credentials['application_id'],
        "X-PAYPAL-REQUEST-DATA-FORMAT"  => "JSON",
        "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON"
      } unless defined? @@headers
    end
    
    def load(file)
      YAML.load_file file
    end
    
    def self.define_call(base_call, base_url)
      define_method(base_call) do |path, data, headers|
        Nestful.post "#{base_url}#{path}", :params => data, :headers => headers
      end
    end  
  end
end