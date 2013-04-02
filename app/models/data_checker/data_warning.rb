class DataChecker::DataWarning < ActiveRecord::Base
  
  belongs_to :subject, polymorphic: true
  
  validates :subject, :error_code, :message, presence: true
  
end