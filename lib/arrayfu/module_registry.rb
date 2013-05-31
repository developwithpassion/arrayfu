module ArrayFu
  module ModuleRegistry
    def self.all_modules
      return [
        GenerateMutators,
        GenerateVisitors,
        GenerateWriters,
        GenerateReaders
      ]
    end

    def self.configure(target, dsl)
      all_modules.each do |the_module| 
        target.extend(the_module.create_using(dsl))
      end
    end
  end
end
