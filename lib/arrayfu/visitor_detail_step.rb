module ArrayFu
  module VisitorDetailStep
    extend self

    def create_using(builder)
      Module.new do
        builder.visitors.each do|visitor|
          define_method(visitor.name) do
            array_var = instance_variable_get(builder.variable_name)
            array_var.each{|item| visitor.visitor.respond_to?(:run_using) ? visitor.visitor.run_using(item) : item.send(visitor.visitor)}
          end
        end
      end
      end
    end
  end
