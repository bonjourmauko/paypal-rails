require 'yaml'
require 'json'
require 'net/http'
require 'net/https'

module Paypal
  REQUESTS = [
      # related to payments
      { :name => 'pay',                               :request_hash => true },
      { :name => 'payment_details',                   :request_hash => false },
      { :name => 'execute_payment',                   :request_hash => true }, # not sure
      { :name => 'get_payment_options',               :request_hash => true }, # not sure
      { :name => 'set_payment_options',               :request_hash => true },
      { :name => 'preapproval',                       :request_hash => true },
      # related to preapprovals                       
      { :name => 'preapproval',                       :request_hash => true }, #not sure
      { :name => 'preapproval_details',               :request_hash => false },
      { :name => 'cancel_preapproval',                :request_hash => false },
      { :name => 'confirm_preapproval',               :request_hash => false }, #not sure
      # others
      { :name => 'refund',                            :request_hash => false },
      { :name => 'convert_currency',                  :request_hash => false },
      { :name => 'get_funding_plans',                 :request_hash => false }, #not sure
      { :name => 'get_allowedfunding_sources',        :request_hash => false }, #not sure
      { :name => 'get_shipping_addresses',            :request_hash => false }, #not sure
      { :name => 'get_available_shipping_addresses',  :request_hash => false } #not sure
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