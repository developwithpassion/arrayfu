module ArrayFu
  class Dsl
    attr_accessor :mutators,:visitors,:criteria,:name,:writable,:readable

    def initialize(name)
      @name = name
      initialize_arrays :mutators,:visitors,:criteria
      initialize_false :writable,:readable
    end

    def mutator(*names,&block)
      names.each{|name| @mutators.push(MutatorDetail.new(name,block))}
    end

    def new_item_must(criteria,fail_option)
      @criteria.push(AddCriterion.new(criteria,fail_option))
    end

    def process_using(name,visitor)
      @visitors.push(VisitorDetail.new(name,visitor))
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

    def configure_using(*configurators)
      configurators.each do|configurator|
        method = configurator.respond_to?(:configure) ? :configure : 'call'.to_sym
        configurator.send(method,self)
      end
    end
  end
end
