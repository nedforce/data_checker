module DataChecker
  module EngineExtensions
    extend ActiveSupport::Concern
    
    module ClassMethods  
      
      def register_data_checkers
        paths.add "app/data_checkers/*", :with => "app/data_checkers", :glob => '*'        

        initializer :register_checkers do |app|
          config.data_checkers += paths["app/data_checkers/*"].existent.map { |path| File.basename(path, '.rb') }          
        end
      end
      
    end

  end
end