class Object
  def initialize_defaults(factory,*items)
    items.each do|item|
      instance_variable_set("@#{item}",factory.call)
    end
  end

  def initialize_arrays(*items)
    initialize_defaults(lambda{[]},*items)
  end

  def initialize_hashes(*items)
    initialize_defaults(lambda{{}},*items)
  end

  def initialize_false(*items)
    initialize_defaults(lambda{false},*items)
  end

  def array(name,&block)
    initialize_arrays(name)
    dsl = ArrayFu::Dsl.new(name)
    yield dsl if block_given?
    ArrayFu::ModuleRegistry.all_modules.each{|module_factory| self.extend(module_factory.run_using(dsl))}
  end

end
