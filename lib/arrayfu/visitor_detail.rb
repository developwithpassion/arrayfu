module ArrayFu
  class VisitorDetail
    attr_accessor :name
    attr_accessor :visitor

    def initialize(name, visitor)
      @name = name
      @visitor = visitor
    end
  end
end
