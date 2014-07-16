#ArrayFu

[![Build Status](http://img.shields.io/travis/developwithpassion/arrayfu.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/developwithpassion/arrayfu.svg)][codeclimate]

[travis]: https://travis-ci.org/developwithpassion/arrayfu
[codeclimate]: https://codeclimate.com/github/developwithpassion/arrayfu

A simple dsl for declaritive arrays. Hopefully the examples below show how it can be used!

Documentation can be found [here](http://rubydoc.info/github/developwithpassion/arrayfu)


##Examples

```ruby
example "Basic" do
  class Example1
    include ArrayFu

    array :names
  end
end

example 'Allow the array to have a read accessor' do
  class Example2
    include ArrayFu

    array(:names) { readable }
  end
  Example2.new.names.should_not be_nil
end

example 'Allow the array to have a write accessor' do
  class Example3
    include ArrayFu

    array(:names) { writeable }
  end
  instance = Example3.new
  new_names = []
  instance.names = new_names
  instance.instance_eval do
    @names.should == new_names
  end
end

example 'Allow the array to have a read and write accessor' do
  class Example4
    include ArrayFu

    array(:names) { read_and_write }
  end
  Example4.new.names.should_not be_nil
end

example 'Add a mutator method to the class that stores the array' do
  class Example5
    include ArrayFu

    array(:names) { mutator :add_item }
  end

  instance = Example5.new
  instance.add_item("JP")
  instance.instance_eval do
    @names.count.should == 1
  end
end

example 'Add multiple mutators to the class that stores the array' do
  class Example6
    include ArrayFu

    array :names do
      mutator :add_item, :add_it, :push_it
    end
  end

  instance = Example6.new
  instance.add_item("JP")
  instance.add_it("JP")
  instance.push_it("JP")
  instance.instance_eval do
    @names.count.should == 3
  end
end

example 'Add a mutator that ignores addition' do
  class Example7
    include ArrayFu

    array :names do
      mutator :add_item do|item|
      end
    end
  end

  instance = Example7.new
  instance.add_item("JP")
  instance.instance_eval do
    @names.count.should == 0
  end
end

example 'Add a mutator that does other custom logic as well as addition' do
  class Example8
    include ArrayFu

    array(:secondary) { readable }

    array :names do
      readable
      mutator :add_item do|item|
        @secondary.push item
        @names.push item
      end
    end
  end

  instance = Example8.new
  instance.add_item("JP")
  instance.names.count.should == 1
  instance.secondary.count.should == 1
end

example 'Add a singular constraint and failure condition to each of the mutators' do
  module NotBeJP
    extend self

    def matches?(item)
      return item != "JP"
    end

    def name
      return "The value should not be JP"
    end
  end

  module CriteriaViolation
    extend self

    def run(description,value)

    end
  end

  class Example9
    include ArrayFu

    array :names do
      readable
      mutator :add_item,:add_it
      new_item_must NotBeJP, CriteriaViolation
    end
  end

  instance = Example9.new
  instance.add_item("JP")
  instance.add_it("JP")
  instance.names.count.should == 0
end

example 'Add multiple constraints and a failure condition to each of the mutators' do
  module NotBeJP
    extend self

    def matches?(item)
      return item != "JP"
    end

    def name
      return "The value should not be JP"
    end
  end

  module NotBeNil
    extend self

    def matches?(item)
      return item != nil
    end

    def name
      return "The value should not be nil"
    end
  end

  module CriteriaViolation
    extend self

    def run(description,value)
      # puts "Criteria violated - #{description} - #{value}"
    end
  end

  class Example10
    include ArrayFu

    array :names do
      readable
      mutator :add_item,:add_it
      addition_constraint NotBeJP
      addition_constraint NotBeNil, CriteriaViolation
    end
  end

  instance = Example10.new
  instance.add_item("JP")
  instance.add_it("JP")
  instance.add_item(nil)
  instance.names.count.should == 0
end

example 'Add an explicit processing visitor to the array' do
  class DisplayItem
    @@number_of_items_displayed = 0
    class << self
      def run_using(item)
        @@number_of_items_displayed += 1
      end
      def item_count
        return @@number_of_items_displayed
      end
    end
  end

  class Example11
    include ArrayFu

    array :names do
      mutator :add_item
      process_using :display_all,DisplayItem
    end
  end

  instance = Example11.new
  (1..10).each{|item| instance.add_item(item)}
  instance.display_all
  DisplayItem.item_count.should == 10
end

example 'Add an method based processing visitor to the array based on a method that exists on the items in the array' do
  class Item
    def process
      Example12.increment
    end
  end

  class Example12
    @@items_visited = 0
    include ArrayFu

    array :names do
      mutator :add_item
      process_using :display_all, :process #the second symbol is the name of a method on an element in the array
    end


    #the process method of the Item class invokes this method (a little bit roundabout, but it hopefully demonstrates the capability
    def self.increment
      @@items_visited += 1
    end
    def self.number_of_items_visited
      @@items_visited
    end
  end

  instance = Example12.new
  (1..10).each{|item| instance.add_item(Item.new)}
  instance.display_all
  Example12.number_of_items_visited.should == 10
end

example 'Augment configuration using configuration block' do
  class ArrayConfigs
    def self.add_another_mutator
      return lambda{|item| item.mutator :another_push}
    end
  end

  class Example13
    include ArrayFu

    array :names do
      readable
      mutator :add_item
      configure_using ArrayConfigs.add_another_mutator
    end
  end

  instance = Example13.new
  instance.add_item("Yo")
  instance.another_push("Yo")
  instance.names.count.should == 2
end

example 'Augment configuration using inline configuration block' do
  class Example14
    include ArrayFu

    array :names do
      readable
      mutator :add_item
      configure_using -> (item) do
        item.mutator :another_pushes
      end
    end
  end

  instance = Example14.new
  instance.add_item("Yo")
  instance.another_pushes("Yo")
  instance.names.count.should == 2
end

example 'Augment configuration using configuration instance (anything that responds to configure with the array definition as the argument)' do

  module ArrayConfiguration
    extend self

    def configure(item)
      item.mutator :once_more
    end
  end

  class Example15
    include ArrayFu

    array :names do
      readable
      mutator :add_item
      configure_using ArrayConfiguration
    end
  end

  instance = Example15.new
  instance.add_item("Yo")
  instance.once_more("Yo")
  instance.names.count.should == 2
end

example 'Augment configuration using configuration block' do

  module ArrayConfiguration
    extend self

    def configuration_block
      Proc.new do|array|
        array.mutator :once_more
      end
    end
  end

  class Example16
    include ArrayFu

    array :names do
      readable
      mutator :add_item
      configure_using ArrayConfiguration.configuration_block
    end
  end

  instance = Example16.new
  instance.add_item("Yo")
  instance.once_more("Yo")
  instance.names.count.should == 2
end

example 'Augment configuration of an existing array' do

  module ExampleConfig1
    extend self

    def configuration_block
      -> (array) { array.mutator :once_more }
    end
  end

  class Example17
    include ArrayFu

    array :names do
      readable
      mutator :add_item
    end

    def initialize
      array :names do
        configure_using ExampleConfig1.configuration_block
      end
      super
    end
  end

  instance = Example17.new
  instance.add_item("Yo")
  instance.once_more("Yo")
  instance.names.count.should == 2
end

example 'Alternate way to augment configuration of an existing array' do

  module ExampleConfig3
    extend self

    def configure(array_definition)
      array_definition.mutator :once_more
    end
  end

  class Example18
    include ArrayFu

    array :names do
      readable
      mutator :add_item
    end

    def initialize(config)
      config.configure(array(:names))
      super
    end
  end

  instance = Example18.new(ExampleConfig3)
  instance.add_item("Yo")
  instance.once_more("Yo")
  instance.names.count.should == 2
end
```
