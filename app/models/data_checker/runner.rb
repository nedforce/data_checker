class DataChecker::Runner

  class << self
    
    attr_reader :checkers
    
    def models *model_classes
      @models = model_classes if model_classes.present?
      @models || []
    end
    
    def scope scope = nil
      @scope = scope if scope && scope.lambda?
      @scope
    end   
    
    def after_check after_check = nil
      @after_check = after_check if after_check && after_check.lambda?
      @after_check
    end   
      
    def checker checker_class, options = {}, attributes = {}, &block
      if block.present?
        checker_name, checker_class = checker_class, Class.new(DataChecker::Checker, &block)
        const_set checker_name.gsub!(/[^a-z0-9\-_]+/, '_').camelize, checker_class
      end

      @checkers ||= []
      checker_class.insert_instance_into @checkers, options
    end
  
    def run!
      raise 'No models specified for runner' unless models.present?
      raise 'No checkers specified for runner' unless checkers.present?
      
      models.each do |model|
        (scope ? scope.call(model) : model.scoped).find_in_batches do |batch|
          batch.each do |subject|
            checkers.each{ |checker| checker.apply(subject) }
            after_check.call(subject) if after_check
          end
        end        
      end
      
      return true
    end
    
  end        
end
