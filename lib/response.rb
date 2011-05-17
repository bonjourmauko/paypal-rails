#module Paypal
#  class Response < Hash
#    
#    def initialize(response_data)
#      @settings = Paypal::Settings.new
#      COMMANDS.each { |command| Response.define_command command }
#      self.merge!(response_data)
#    end
#    
#    def self.define_command(command)
#      define_method("#{command[:name]}_url") do
#        key_value = self["#{command[:key_name]}"]
#        return "#{@settings.paypal_base_url}/webscr?cmd=_ap-#{command[:name]}&#{command[:key_name].downcase}=#{key_value}" if key_value
#        nil
#      end
#    end
#    
#    def success?
#      self['responseEnvelope']['ack'] == 'Success'
#    end
#    
#    def errors
#      self['error'].inspect rescue nil
#    end
#    
#  end  
#end