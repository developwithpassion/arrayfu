module ArrayFu
  class AddCriterion
    attr_accessor :criteria
    attr_accessor :failure_strategy

    def initialize(criteria,failure_strategy)
      @criteria = criteria
      @failure_strategy = failure_strategy
    end

    def apply_to(value)
      result = criteria.matches?(value)
      failure_strategy.run(criteria.name,value) unless result
      return result
    end
  end
end
