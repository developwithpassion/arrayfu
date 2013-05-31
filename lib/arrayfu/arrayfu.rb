module ArrayFu
  include Initializer

  def self.included(base)
    base.extend ClassMethods 
  end

  def initialize_arrayfu
    self.class.each_array_definition do |array_definition|
      initialize_arrays(array_definition.name)
      ArrayFu::ModuleRegistry.configure(self, array_definition)      
    end
  end

  module ClassMethods
    def array_definitions
      @array_definitions ||= []
    end

    def each_array_definition(&block)
      array_definitions.each &block
    end

    def array(name, &block)
      array_definition = ArrayDefinition.new(name)
      yield array_definition if block_given?
      array_definitions << array_definition
      array_definition
    end
  end
end
