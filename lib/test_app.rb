class TestApp < ActionController::Metal
  include ActionController::Rendering
  append_view_path "#{Rails.root}/app/views"
  
  def index
    render
  end
  
  def buy
    pay_request = Paypal::Request.new

    data = {
    "returnUrl" => "http://localhost:3000/download", 
    "requestEnvelope" => {"errorLanguage" => "en_US"},
    "currencyCode"=>"USD",  
    "receiverList"=>{"receiver"=>[{"email"=>"writer_1305222415_biz@pictorical.com", "amount"=>"10.00"}]},
    "cancelUrl"=>"http://localhost:3000/canceled",
    "actionType"=>"PAY",
    "ipnNotificationUrl"=>"http://localhost:3000/ipn_endpoint"
    }

    pay_response = pay_request.pay(data)
    
    if pay_response.success?
      redirect_to pay_response.approve_paypal_payment_url
    else
      raise "#{pay_response.errors}"
    end    
  end
  
  def download
    render
  end
end