class DataChecker::DatabaseLogger
  
  def warn subject, error_code, message
    DataChecker::DataWarning.create(subject: subject, error_code: error_code, message: message)
  end
  
end