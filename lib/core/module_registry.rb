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
  end
end
