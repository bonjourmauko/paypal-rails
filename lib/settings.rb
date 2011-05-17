require 'yaml'
require 'json'
require 'net/http'
require 'net/https'

module Paypal
  REQUESTS = [
      { :name => 'pay',                 :request_hash => true },
      { :name => 'set_payment_options', :request_hash => true },
      { :name => 'preapproval',         :request_hash => true },
      { :name => 'payment_details',     :request_hash => false },
      { :name => 'preapproval_details', :request_hash => false },
      { :name => 'cancel_preapproval',  :request_hash => false },
      { :name => 'convert_currency',    :request_hash => false },
      { :name => 'refund',              :request_hash => false }
    ] unless defined? REQUESTS
    
  COMMANDS = [
      { :name => 'payment',     :key_name => 'payKey' },
      { :name => 'preapproval', :key_name => 'preapprovalKey' }
    ] unless defined? COMMANDS
    
  BASE_MAPPINGS = [
      'api', 
      'paypal'
    ] unless defined? BASE_MAPPINGS
  
  class Settings
    attr_accessor :credentials,
                  :paypal_base_url,
                  :api_base_url,
                  :headers
    
    def initialize
      settings      = self.load File.join(Rails.root, 'config', 'paypal.yml')
      @env          = Rails.env
      @credentials  = settings['credentials'][@env]
      
      BASE_MAPPINGS.each { |name| instance_variable_set("@#{name}_base_url", eval("settings['base_url_mapping']['#{name}'][@env]")) }
      
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
      YAML.load_file file
    end
  end
end