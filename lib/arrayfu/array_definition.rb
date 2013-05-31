module ArrayFu
  class ArrayDefinition
    include Initializer

    attr_accessor :name
    attr_accessor :writable
    attr_accessor :readable
    attr_accessor :mutators
    attr_accessor :visitors 
    attr_accessor :constraints

    def initialize(name)
      @name = name
      initialize_arrays :mutators, :visitors, :constraints
      initialize_false :writable, :readable
    end

    def mutator(*names, &block)
      names.each do |mutator_name| 
        self.mutators.push(MutatorDefinition.new(mutator_name, block))
      end
    end

    module NoFailure
      extend self

      def run(description, value)
      end
    end

    def addition_constraint(constraint, fail_option = NoFailure)
      self.constraints.push(ItemConstraint.new(constraint, fail_option))
    end
    alias :new_item_must :addition_constraint

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
