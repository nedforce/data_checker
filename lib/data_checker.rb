require 'nokogiri'

module DataChecker
  extend ActiveSupport::Autoload

  # Load Classes
  
  autoload :EngineExtensions
  
  autoload_under 'loggers' do
    autoload :RailsLogger    
    autoload :DatabaseLogger
  end
end

class Rails::Engine
  include DataChecker::EngineExtensions
end

require 'data_checker/engine'