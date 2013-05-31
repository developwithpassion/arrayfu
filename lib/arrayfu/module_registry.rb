module ArrayFu
  class ModuleRegistry
    def self.all_modules
      return [
        MutatorStep,
        VisitorDetailStep,
        WriteableStep,
        ReadableStep
      ]
    end

    def self.configure(target, dsl)
      all_modules.each do |the_module| 
        target.extend(the_module.create_using(dsl))
      end
    end
  end
end
