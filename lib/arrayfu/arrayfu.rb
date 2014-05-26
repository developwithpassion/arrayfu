module ArrayFu
  include Initializer

  def self.included(base)
    base.extend ClassMethods 
  end

  def initialize(*args)
    self.class.each_array_definition do |array_definition|
      initialize_arrays(array_definition.name)
      ArrayFu::ModuleRegistry.configure(self, array_definition)      
    end
  end

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
