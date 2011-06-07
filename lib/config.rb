module AdaptivePayments
  
  REQUESTS = [
    # related to payments
    'pay',
    'payment_details', 
    'execute_payment', 
    'get_payment_options', 
    'set_payment_options', 
    'preapproval',
    # related to preapprovals                       
    'preapproval', 
    'preapproval_details', 
    'cancel_preapproval', 
    'confirm_preapproval',
    # others
    'refund', 
    'convert_currency', 
    'get_funding_plans', 
    'get_allowedfunding_sources', 
    'get_shipping_addresses', 
    'get_available_shipping_addresses'
  ] unless defined? REQUESTS
  
  COMMANDS = [
    { :name => 'payment',     :key_name => 'payKey' },
    { :name => 'preapproval', :key_name => 'preapprovalKey' }
  ] unless defined? COMMANDS
  
  BASE_MAPPINGS = [
    'api', 
    'paypal'
  ] unless defined? BASE_MAPPINGS

end