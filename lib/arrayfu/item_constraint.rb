module ArrayFu
  class ItemConstraint
    attr_accessor :constraint
    attr_accessor :failure_action

    def initialize(constraint, failure_action)
      @constraint = constraint
      @failure_action = failure_action
    end

    def apply_to(value)
      result = constraint.matches?(value)
      failure_action.run(constraint.name, value) unless result
      return result
    end
  end
end
