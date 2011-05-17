Paypal::Application.routes.draw do

  root :to => TestApp.action(:index)
  match "/buy" => TestApp.action(:buy)
  match "/download" => TestApp.action(:download)
  match "/ipn_listener" => Paypal::IpnListener
  
end
