module ArrayFu
  module GenerateWriters
    extend self

    def create_using(builder)
      Module.new do
        if (builder.writeable?)
          define_method("#{builder.name}=") do|value|
            instance_variable_set(builder.variable_name, value)
          end
        end
      end
    end
  end
end
