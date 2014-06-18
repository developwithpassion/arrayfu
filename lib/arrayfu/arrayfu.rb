# Main module that can be mixed in to allow for declaritive array definitions
#
module ArrayFu
  include Initializer

  def self.included(base)
    base.extend ClassMethods 
  end

  # This method is here to ensure that all of the array definitions are expanded and a variable instance is assigned to the variable name specified by the array
  # If you are mixing in this module and the class has its own constructor definition, make sure you call super to ensure that array initialization occurs correctly as shown:
  #
  #   class SomeClass
  #     include ArrayFu
  #
  #     array :names
  #
  #     def initialize(some_value)
  #       super
  #     end
  #   end
  #
  # If your class does not contain custom constructor logic, no extra code is needed:
  #
  #
  #   class SomeClass
  #     include ArrayFu
  #
  #     array :names
  #   end
  def initialize(*args)
    self.class.each_array_definition do |array_definition|
      initialize_arrays(array_definition.name)
      ArrayFu::ModuleRegistry.configure(self, array_definition)      
    end
  end

  # Array definition dsl entry point
  #
  # == Parameters:
  # name::
  #   A name that will be used to initialize a variable on the class that is including this module.
  #   It will serve as the backing array for the array definition
  #
  # &block::
  #   A configuration block that will serve to configure an {ArrayFu::ArrayDefinition}
  #
  # Examples:
  #
  # * Define a basic array
  #     
  #     class SomeClass
  #       include ArrayFu
  #         
  #       array :names
  #     end
  #
  # * Define a basic array that supports a read accessor
  #     
  #     class SomeClass
  #       include ArrayFu
  #         
  #       array :names { readable }
  #     end
  #
  # * Define a basic array that supports a write accessor
  #     
  #     class SomeClass
  #       include ArrayFu
  #         
  #       array :names { writeable }
  #     end
  #
  # * Define a basic array that supports both read and write accessors
  #     
  #     class SomeClass
  #       include ArrayFu
  #         
  #       array :names { read_and_write }
  #     end
  def array(name, &block)
    self.class.array(name, &block)
  end

  module ClassMethods
    def array_definitions
      @array_definitions ||= {}
    end

    def each_array_definition(&block)
      array_definitions.values.each &block
    end

    def array_definition(name)
      array_definitions[name] ||= ArrayDefinition.new(name)
    end

    def array(name, &block)
      definition = array_definition(name)
      definition.instance_eval(&block) if block_given?
      definition
    end
  end
end
