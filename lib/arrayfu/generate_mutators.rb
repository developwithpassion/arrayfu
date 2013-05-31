module ArrayFu
  module GenerateMutators
    extend self

    def create_using(builder)
      Module.new do
        builder.mutators.each do|mutator|
          define_method(mutator.name) do|value|
            array_var = instance_variable_get(builder.variable_name)
            continue_add = true

            builder.criteria.each do |criteria| 
              continue_add &= criteria.apply_to(value)
            end

            return unless continue_add

            unless mutator.block.nil?
              self.instance_exec value, &mutator.block
            else
              array_var.push(value)
            end
          end
        end
      end
      end
    end
  end
