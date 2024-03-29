class TestApp < ActionController::Metal
  include ActionController::Rendering
  include ActionController::Redirecting
  append_view_path "#{Rails.root}/app/views"
  
  def index
    render
  end
  
  def buy
    request = AdaptivePayments::Transaction.new

    data = {
      "returnUrl" => "http://localhost:3000/download", 
      "requestEnvelope" => {"errorLanguage" => "en_US"},
      "currencyCode"=>"USD",  
      "receiverList"=>{"receiver"=>[
          {"email"=>"writer_1305222415_biz@pictorical.com", "amount"=>"10.00"},
          {"email"=>"paypal_1305220395_biz@pictorical.com", "amount"=>"5.00"}
        ]},
      "cancelUrl"=>"http://localhost:3000/canceled",
      "actionType"=>"PAY",
      "ipnNotificationUrl"=>"http://localhost:3000/ipn_listener"
    }

    request.pay(data)
    
    if request.success?
      redirect_to request.payment_url
    else
      raise "#{request.errors}"
    end
  end
  
  
  
#  def buy
    #if pay_response.success?
    #  raise "#{pay_response}"
    #  #redirect_to pay_response.payment_url
    #else
    #  raise "#{pay_response.errors}"
    #end    
#  end
  
  def download
    render
  end
end