module DataChecker
  class Engine < Rails::Engine
    config.data_checkers = Set.new  
    config.checker_logger = DataChecker::RailsLogger  
    config.last_checked_field = :last_checked_at
    register_data_checkers
  end
  
  def self.config; DataChecker::Engine.config; end
  def self.logger; @logger ||= DataChecker.config.checker_logger.new; end 
end