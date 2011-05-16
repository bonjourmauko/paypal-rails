module Paypal
  class Response < Hash
  
    COMMANDS = [
        { :name => 'payment', :key_name => 'payKey' },
        { :name => 'preapproval', :key_name => 'preapprovalKey' }
      ]
    
    def initialize(response_data)
      @config = Paypal::Config.new
      COMMANDS.each { |command| Response.define_command command }
      self.merge!(response_data)
    end
    
    def self.define_command(command)
      define_method("#{command[:name]}_url") do
        key_value = self["#{command[:key_name]}"]
        return "#{@config.paypal_base_url}/webscr?cmd=_ap-#{command[:name]}&#{command[:key_name].lowercase}=#{key_value}" if key_value
        nil
      end
    end
    
  end  
end