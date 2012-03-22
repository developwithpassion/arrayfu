module DevelopWithPassion
  module Arrays
    class MutatorStep
      def run_using(builder)
        Module.new do
          builder.mutators.each do|mutator|
            define_method(mutator.name) do|value|
              array_var = instance_variable_get("@#{builder.name}")
              continue_add = true
              builder.criteria.each{|criteria| continue_add &= criteria.apply_to(value)}
              return unless continue_add
              array_var.push(value) unless mutator.block
              mutator.block.call(value) if mutator.block
            end
          end
        end
        end
      end
    end
  end
