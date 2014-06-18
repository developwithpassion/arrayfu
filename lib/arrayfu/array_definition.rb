module ArrayFu
  # A builder for specifying behaviours exposed by a class that defines arrays
  class ArrayDefinition
    include Initializer

    # The name that will be given to this array definition, it will also become a variable named @[name] on the class that defined this array
    attr_reader :name
    # Flag for writeability
    attr_accessor :writeable
    # Flag for readability
    attr_accessor :readable
    # List of mutator definitions for this array
    attr_accessor :mutators
    # List of processing visitors
    attr_accessor :visitors 

    # The list of constraints specified for this array definition
    attr_accessor :constraints

    # Create an array definition with the specified name
    #
    # == Parameters:
    # @name:: 
    #   Name given to the array definition. This name will also be used to generate a variable on the target class named: @[name]
    def initialize(name)
      @name = name
      initialize_arrays :mutators, :visitors, :constraints
      initialize_false :writeable, :readable
    end

    # Flag that the class that is defining this array will expose both a reader and writer for the array variable
    #
    # Example:
    #
    #   class SomeClass
    #     include ArrayFu
    #
    #     array :names { read_and_write }
    #   end
    #
    # The above is the same as the following
    #   
    #   class SomeClass
    #     attr_accessor :names
    #
    #     def initialize
    #       @names = []
    #     end
    #   end
    def read_and_write
      writeable
      readable
    end


    # Flag that the class that is defining this array will expose a writer for the array variable
    def writeable
      @writeable = true
    end

    # Flag that the class that is defining this array will expose a writer for the array variable
    def readable
      @readable = true
    end

    # Used by internal infrastructure to determine if this arraydefinition should expose a writer for the array variable
    def writeable?
      @writeable ||= false
    end

    # Used by internal infrastructure to determine if this arraydefinition should expose a reader for the array variable
    def readable?
      @readable ||= false
    end

    # This method allows for external configurators to customize the behaviour of this array definition
    # == Parameters:
    # configurators::
    #   One or many objects/blocks (can be a mix). If a configurator is an object, it must respond to the following method:
    #     def configure(definition) 
    #   Where definition is an {ArrayDefinition}.
    #   
    #   If a configurator is a block, it will be a block that takes a singular parameter which is the {ArrayDefinition}
    # Examples:
    #
    # * Configuring using an object
    #
    #     class SomeConfigurator
    #       def self.configure(array_definition)
    #         array_definition.mutator :add_it
    #       end
    #     end
    #
    #     class SomeClass
    #       include ArrayFu
    #
    #       array :names do
    #         configure_using SomeConfigurator
    #       end
    #     end
    #
    #     instance = SomeClass.new
    #     instance.add_it('JP')
    #
    # * Configuring using a lambda
    #
    #     class SomeClass
    #       include ArrayFu
    #
    #       array :names do
    #         configure_using -> (item) do
    #           item.mutator :add_it
    #         end
    #       end
    #     end
    #
    #     instance = SomeClass.new
    #     instance.add_it('JP')
    def configure_using(*configurators)
      configurators.each do|configurator|
        method = configurator.respond_to?(:configure) ? :configure : 'call'.to_sym
        configurator.send(method, self)
      end
    end

    # Method used to specify a list of methods that will be exposed on the class that is defining this array. The methods are write methods that will push data back to the underlying array
    #
    # == Parameters:
    # names::
    #   Method names that will be used to expose push methods to this array
    # &block::
    #   If provided, this block will be run anytime the mutator method is invoked. It's single parameter is the new item that is attempting to be added to the underlying array
    #   if you provide this block, and dont push the item parameter back to the original array, no changes will happen to the underlying array
    #
    # Examples:
    #
    #     class SomeClass
    #       include ArrayFu
    #
    #       array :names { mutator :add_item }
    #     end
    #
    # The above will generate an instance method named :add_item on the SomeClass class. When you call this method, the names array will have an item pushed to it:
    #
    #     instance = SomeClass.new
    #     instance.add_item('Hello') #the @names array variable will now contain ['Hello']
    #
    # You can specify multiple mutators at once:
    #
    #     class SomeClass
    #       include ArrayFu
    #
    #       array :names do
    #         mutator :add_item, 
    #                 :add_another, 
    #                 :add_one_more 
    #       end
    #     end
    #
    #     instance = SomeClass.new
    #     instance.add_item('JP')
    #     instance.add_another('Yeah')
    #     instance.add_one_more('Yep')
    # 
    # Example:
    #
    # * A mutator with custom logic in a block
    #
    #     class SomeClass
    #       include ArrayFu
    #
    #       array :names do
    #         mutator :add_one do |item|
    #           puts 'About to add one new item #{item}'
    #           @names.push(item) #if this does not happen, no changes will occur to the underlying array
    #         end
    #       end
    #     end
    #
    #     instance = SomeClass.new
    #     instance.add_one('JP') # at this point we will see a console out
    #       
    def mutator(*names, &block)
      names.each do |mutator_name| 
        self.mutators.push(MutatorDefinition.new(mutator_name, block))
      end
    end

    # Null object implementation for a constraint failure (No-op)
    module NoFailure
      extend self

      def run(description, value)
      end
    end

    # Run each of its {ArrayFu::MutatorDefinition} against the provided block
    def each_mutator(&block)
      mutators.each &block 
    end

    # Run each of its {ArrayFu::ItemConstraint} against the provided block
    def each_constraint(&block)
      constraints.each &block
    end

    # Run each of its {ArrayFu::VisitorDefinition} against the provided block
    def each_visitor(&block)
      visitors.each &block
    end

    # Adds a constraint that must be met for any new item being passed to a mutator method
    # == Parameters:
    # constraint::
    #   An object that responds to the following 2 methods:
    #     name: - Should return a descriptive name for the constraint
    #     matches?(item) - The constraint method, it will be called with any new item about to be added
    # fail_option (defaults to {ArrayFu::ArrayDefinition::NoFailure})::
    #   An object that responds to the following methods:
    #     run(description, value) - Behaviour to run when the constraint is not met. It is given the description of the failed constraint, and the value
    #     that did not meet the constraint
    def addition_constraint(constraint, fail_option = NoFailure)
      self.constraints.push(ItemConstraint.new(constraint, fail_option))
    end
    alias :new_item_must :addition_constraint

    def process_using(name,visitor)
      self.visitors.push(VisitorDefinition.new(name, visitor))
    end

    # Method used by internal builder mechanism. Specifies the name that will be used for the backing array variable for this array definition
    def variable_name
      "@#{@name}"
    end
  end
end
