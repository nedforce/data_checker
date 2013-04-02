class DataChecker::DatabaseLogger
  
  def warn subject, error_code, message
    unless DataChecker::DataWarning.exists?(subject_id: subject.id, subject_type: subject.class.name, error_code: error_code, message: message)
      DataChecker::DataWarning.create(subject: subject, error_code: error_code, message: message)
    end
  end
  
end