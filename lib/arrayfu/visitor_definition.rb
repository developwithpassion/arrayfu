module ArrayFu
  class VisitorDefinition
    attr_accessor :name
    attr_accessor :visitor

    def initialize(name, visitor)
      @name = name
      @visitor = visitor
    end

    def process(item)
      if visitor.respond_to?(:run_using)
        visitor.run_using(item)
      else
        item.send(visitor)
      end
    end
  end
end
