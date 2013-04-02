class DataChecker::RailsLogger
  
  def warn subject, error_code, message
    Rails.logger.info "[DataChecker][#{error_code.upcase}][#{I18n.l(Time.now, :format => :long)}] #{subject.class.model_name.human} ##{subject.id}: #{message}"
  end
  
end