module ArrayFu
  class ArrayDefinition
    include Initializer

    attr_accessor :mutators
    attr_accessor :visitors 
    attr_accessor :criteria
    attr_accessor :name
    attr_accessor :writable
    attr_accessor :readable

    def initialize(name)
      @name = name
      initialize_arrays :mutators, :visitors, :criteria
      initialize_false :writable, :readable
    end

    def mutator(*names, &block)
      names.each do |mutator_name| 
        self.mutators.push(MutatorDefinition.new(mutator_name, block))
      end
    end

    def new_item_meets_constraint(criteria,fail_option)
      self.criteria.push(AddCriterion.new(criteria, fail_option))
    end
    alias :new_item_must :new_item_meets_constraint

    def process_using(name,visitor)
      self.visitors.push(VisitorDefinition.new(name, visitor))
    end

    def read_and_write
      writable
      readable
    end

    def writable
      @writable = true
    end

    def readable
      @readable = true
    end

    def writable?
      @writable ||= false
    end

    def readable?
      @readable ||= false
    end

    def configure_using(*configurators)
      configurators.each do|configurator|
        method = configurator.respond_to?(:configure) ? :configure : 'call'.to_sym
        configurator.send(method, self)
      end
    end

    def variable_name
      "@#{@name}"
    end
  end
end
