module ArrayFu
  class ModuleRegistry
    def self.all_modules
      return [
        MutatorStep.new,
        VisitorDetailStep.new,
        WriteableStep.new,
        ReadableStep.new
      ]
    end

    def self.configure(target,dsl)
      all_modules.each{|the_module| target.extend(the_module.create_using(dsl))}
    end
  end
end
