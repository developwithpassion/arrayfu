module ArrayFu
  class VisitorDefinition
    attr_accessor :name
    attr_accessor :visitor

    def initialize(name, visitor)
      @name = name
      @visitor = visitor
    end
  end
end
