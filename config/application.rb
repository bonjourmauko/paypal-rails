require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Paypal
  class Application < Rails::Application
    
    # Generator Settings
    config.generators do |g|
      g.template_engine :haml
    end

    # Global Sass Option
    Sass::Plugin.options[:template_location] = { 'app/stylesheets' => 'public/stylesheets' }
  

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(jquery.min rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end
