module ArrayFu
  class MutatorDefinition
    attr_reader :name
    attr_reader :block

    def initialize(name, block)
      @name = name
      @block = block
    end
  end
end
