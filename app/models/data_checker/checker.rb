class DataChecker::Checker

  def self.insert_instance_into checkers, options = {}
    new.tap do |new_checker|
      checker_before_or_after = options[:before] || options[:after]
      checker_before_or_after = new_checker.site.class.const_get(checker_before_or_after.gsub!(/[^a-z0-9\-_]+/, '_').underscore.camelize) if checker_before_or_after.is_a?(String)
      
      if checker_before_or_after && checkers.any?{|checker| checker.is_a?(checker_before_or_after) }
        if options[:before] 
          checkers.insert(checkers.index{|checker| checker.is_a?(checker_before_or_after) }, new_checker)
        else 
          checkers.insert(checkers.index{|checker| checker.is_a?(checker_before_or_after) } + 1, new_checker)
        end
      else
        checkers << new_checker
      end      
    end
  end

  def apply subject; end
  
  def logger
    DataChecker.logger    
  end

  def to_s
    self.class.name
  end
  
  delegate :warn, to: :logger

end