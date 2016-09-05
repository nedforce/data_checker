module DataChecker
  class Engine < Rails::Engine
    config.data_checkers = Set.new
    config.checker_logger = DataChecker::RailsLogger
    config.link_checker_site_url = 'http://example.org'
    config.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36'

    register_data_checkers
  end

  def self.config; DataChecker::Engine.config; end
  def self.logger; @logger ||= DataChecker.config.checker_logger.new; end
end