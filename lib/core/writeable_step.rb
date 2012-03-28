module ArrayFu
  class WriteableStep
    def run_using(builder)
      Module.new do
        if (builder.writable)
          define_method("#{builder.name}=") do|value|
            instance_variable_set("@#{builder.name}",value)
          end
        end
      end
      end
    end
  end
