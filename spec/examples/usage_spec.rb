require 'spec_helper'

example "Basic" do
  class SomeClass
    include ArrayFu

    array :names
  end
end

example 'Allow the array to have a read accessor' do
  class SomeClass
    include ArrayFu

    array(:names) { readable }
  end
  SomeClass.new.names.should_not be_nil
end

example 'Allow the array to have a write accessor' do
  class SomeClass
    include ArrayFu

    array(:names) { writable }
  end
  SomeClass.new.names.should_not be_nil
end

example 'Allow the array to have a read and write accessor' do
  class SomeClass
    include ArrayFu

    array(:names) { read_and_write }
  end
  SomeClass.new.names.should_not be_nil
end

example 'Add a mutator method to the class that stores the array' do
  class SomeClass
    include ArrayFu

    array(:names) { mutator :add_item }
  end

  items = SomeClass.new
  items.add_item("JP")
  items.names.count.should == 1
end

example 'Add multiple mutators to the class that stores the array' do
  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item, :add_it, :push_it
    end
  end

  items = SomeClass.new
  items.add_item("JP")
  items.add_it("JP")
  items.push_it("JP")
  items.names.count.should == 3
end

example 'Add a mutator that ignores addition' do
  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item do|item|
      end
    end
  end

  items = SomeClass.new
  items.add_item("JP")
  items.names.count.should == 0
end

example 'Add a mutator that does other custom logic as well as addition' do
  class SomeClass
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

  items = SomeClass.new
  items.add_item("JP")
  items.names.count.should == 1
  items.secondary.count.should == 1
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

  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item,:add_it
      new_item_must NotBeJP, CriteriaViolation
    end
  end

  items = SomeClass.new
  items.add_item("JP")
  items.add_it("JP")
  items.names.count.should == 0
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

  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item,:add_it
      addition_constraint NotBeJP
      addition_constraint NotBeNil, CriteriaViolation
    end
  end

  items = SomeClass.new
  items.add_item("JP")
  items.add_it("JP")
  items.add_item(nil)
  items.names.count.should == 0
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

  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item
      process_using :display_all,DisplayItem
    end
  end

  items = SomeClass.new
  (1..10).each{|item| items.add_item(item)}
  items.display_all
  DisplayItem.item_count.should == 10
end

example 'Add an method based processing visitor to the array based on a method that exists on the items in the array' do
  class Item
    def process
      SomeClass.increment
    end
  end

  class SomeClass
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

  items = SomeClass.new
  (1..10).each{|item| items.add_item(Item.new)}
  items.display_all
  SomeClass.number_of_items_visited.should == 10
end

example 'Augment configuration using configuration block' do
  class ArrayConfigs
    def self.add_another_mutator
      return lambda{|item| item.mutator :another_push}
    end
  end

  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item
      configure_using ArrayConfigs.add_another_mutator
    end
  end

  items = SomeClass.new
  items.add_item("Yo")
  items.another_push("Yo")
  items.names.count.should == 2
end

example 'Augment configuration using configuration instance (anything that responds to configure with the array definition as the argument)' do

  module ArrayConfiguration
    extend self

    def configure(item)
      item.mutator :once_more
    end
  end

  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item
      configure_using ArrayConfiguration
    end
  end

  items = SomeClass.new
  items.add_item("Yo")
  items.once_more("Yo")
  items.names.count.should == 2
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

  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item
      configure_using ArrayConfiguration.configuration_block
    end
  end

  items = SomeClass.new
  items.add_item("Yo")
  items.once_more("Yo")
  items.names.count.should == 2
end

example 'Augment configuration of an existing array' do

  module ArrayConfiguration
    extend self

    def configuration_block
      Proc.new do|array|
        array.mutator :once_more
      end
    end
  end

  class SomeClass
    include ArrayFu

    array :names do
      mutator :add_item
    end

    def initialize
      super
      array :names do
        configure_using ArrayConfiguration.configuration_block
      end
    end
  end

  items = SomeClass.new
  items.add_item("Yo")
  items.once_more("Yo")
  items.names.count.should == 2
end
