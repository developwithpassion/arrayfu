module ArrayFu
  class MutatorDefinition
    attr_reader :name
    attr_reader :block

    def initialize(name, block)
      @name = name
      @block = block
    end

    def run(target, value)
      target.instance_exec value, &block
    end
  end
end
