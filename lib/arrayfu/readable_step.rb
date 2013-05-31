module ArrayFu
  module ReadableStep
    extend self

    def create_using(builder)
      Module.new do
        if (builder.readable)
          define_method(builder.name) do
            return instance_variable_get(builder.variable_name)
          end
        end
      end
      end
    end
  end
