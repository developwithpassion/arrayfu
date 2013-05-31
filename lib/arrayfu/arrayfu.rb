module ArrayFu
  include Initializer

  def self.included(base)
    base.extend ClassMethods 
  end

  def initialize_arrayfu
    self.class.arrays.each do |array|
      initialize_arrays(array.name)
      ArrayFu::ModuleRegistry.configure(self, array)      
    end
  end

  module ClassMethods
    def arrays
      @arrays ||= []
    end

    def array(name, &block)
      definition = ArrayDefinition.new(name)
      yield definition if block_given?
      arrays << definition
    end
  end
end
