class DataChecker::DataWarning < ActiveRecord::Base
  
  belongs_to :subject, polymorphic: true
  
  validates :subject, :error_code, :message, presence: true
  
  def self.human_error_code error_code
    I18n.t(error_code, scope: 'data_checker.error_codes')
  end
  
end