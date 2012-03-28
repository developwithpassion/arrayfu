module ArrayFu
  class AddCriterion
    attr_accessor :criteria,:failure_strategy

    def initialize(criteria,failure_strategy)
      @criteria = criteria
      @failure_strategy = failure_strategy
    end

    def apply_to(value)
      result = @criteria.is_satisfied_by(value)
      @failure_strategy.run(@criteria.name,value) unless result
      return result
    end
  end
end
