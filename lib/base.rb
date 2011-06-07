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
        url = URI.parse base_url
        http = Net::HTTP.new(url.host, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        resp, response_data = http.post(path, data, headers)
        response_data
      end
    end
    
  end
end