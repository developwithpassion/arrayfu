module ArrayFu
  class ReadableStep
    def run_using(builder)
      Module.new do
        if (builder.readable)
          define_method(builder.name) do
            return instance_variable_get("@#{builder.name}")
          end
        end
      end
      end
    end
  end
