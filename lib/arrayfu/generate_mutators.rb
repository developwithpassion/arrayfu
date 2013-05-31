module ArrayFu
  module GenerateMutators
    extend self

    def create_using(builder)
      Module.new do
        builder.each_mutator do |mutator|
          define_method(mutator.name) do|value|
            array_var = instance_variable_get(builder.variable_name)
            continue_add = true

            builder.each_constraint do |constraint| 
              continue_add &= constraint.apply_to(value)
            end

            return unless continue_add

            if mutator.block
              mutator.run(self, value)
            else
              array_var.push(value)
            end
          end
        end
      end
    end
  end
end
