module AdaptivePayments
  class HttpConnection
    def initialize
      @@settings ||= AdaptivePayments::Base.new
      BASE_MAPPINGS.each { |base_name| HttpConnection.define_base_name base_name }
    end
  
    def self.define_base_name(base_name)
      define_method("#{base_name}_call") do |path, data, headers|
        url = eval "URI.parse @@settings.#{base_name}_base_url"
        http = Net::HTTP.new(url.host, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        resp, response_data = http.post(path, data, headers)
        response_data
      end
    end
  end
end