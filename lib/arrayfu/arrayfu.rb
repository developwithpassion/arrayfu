module ArrayFu
  include Initializer

  def self.included(base)
    base.extend ClassMethods 
  end

  def initialize_custom_arrays
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
      dsl = ArrayFu::Dsl.new(name)
      yield dsl if block_given?
      arrays << dsl
    end
  end
end
