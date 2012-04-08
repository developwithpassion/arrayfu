module ArrayFu
  class MutatorDetail
    attr_accessor :name,:block

    def initialize(name,block)
      @name = name
      @block = block
    end
  end
end
