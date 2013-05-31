module ArrayFu
  class ItemConstraint
    attr_accessor :constraint
    attr_accessor :failure_strategy

    def initialize(constraint, failure_strategy)
      @constraint = constraint
      @failure_strategy = failure_strategy
    end

    def apply_to(value)
      result = constraint.matches?(value)
      failure_strategy.run(constraint.name, value) unless result
      return result
    end
  end
end
