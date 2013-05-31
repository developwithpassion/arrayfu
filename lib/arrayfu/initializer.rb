module ArrayFu
  module Initializer
    def initialize_defaults(builder, *names)
      names.each do|item|
        instance_variable_set("@#{item}", builder.call)
      end
    end

    def initialize_arrays(*names)
      initialize_defaults(lambda { [] }, *names)
    end

    def initialize_hashes(*names)
      initialize_defaults(lambda { {} }, *names)
    end

    def initialize_false(*names)
      initialize_defaults(lambda { false }, *names)
    end
  end
end
