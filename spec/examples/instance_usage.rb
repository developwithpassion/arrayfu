require 'spec_helper'

example "Basic" do
  class SomeClass
    def initialize
      array :names
    end
  end

  SomeClass.new.names.should_not be_nil 
end

example 'Allow the array to have a read accessor' do
  class SomeClass
    def initialize
      array :names do|a|
        a.readable
      end
    end
  end
  SomeClass.new.names.should_not be_nil
end

example 'Allow the array to have a write accessor' do
  class SomeClass
    def initialize
      array :names do|a|
        a.writable
      end
    end
  end
  SomeClass.new.names.should_not be_nil
end

example 'Allow the array to have a read and write accessor' do
  class SomeClass
    def initialize
      array :names do|a|
        a.read_and_write
      end
    end
  end
  SomeClass.new.names.should_not be_nil
end

example 'Add a mutator method to the class that stores the array' do
  class SomeClass
    def initialize
      array :names do|a|
        a.mutator :add_item
      end
    end
  end

  items = SomeClass.new
  items.add_item("JP")
  items.names.count.should == 1
end

example 'Add multiple mutators to the class that stores the array' do
  class SomeClass
    def initialize
      array :names do|a|
        a.mutator :add_item,:add_it,:push_it
      end
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
    def initialize
      array :names do|a|
        a.mutator :add_item do|item|
        end
      end
    end
  end

  items = SomeClass.new
  items.add_item("JP")
  items.names.count.should == 0
end

example 'Add a mutator that does other custom logic as well as addition' do
  class SomeClass
    def initialize
      array :secondary
      array :names do|a|
        a.mutator :add_item do|item|
          @secondary.push item
          @names.push item
        end
      end
    end
  end

  items = SomeClass.new
  items.add_item("JP")
  items.names.count.should == 1
  items.secondary.count.should == 1
end

example 'Add a singular constraint and failure condition to each of the mutators' do
  class NotBeJP
    include Singleton
    def is_satisfied_by(item)
      return item != "JP"
    end
    def name
      return "The value should not be JP"
    end
  end
  class CriteriaViolation
    include Singleton
    def run(description,value)

    end
  end

  class SomeClass
    def initialize
      array :names do|a|
        a.mutator :add_item,:add_it
        a.new_item_must NotBeJP.instance,CriteriaViolation.instance
      end
    end
  end

  items = SomeClass.new
  items.add_item("JP")
  items.add_it("JP")
  items.names.count.should == 0
end

example 'Add multiple constraints and a failure condition to each of the mutators' do
  class NotBeJP
    include Singleton
    def is_satisfied_by(item)
      return item != "JP"
    end
    def name
      return "The value should not be JP"
    end
  end
  class NotBeNil
    include Singleton
    def is_satisfied_by(item)
      return item != nil
    end
    def name
      return "The value should not be nil"
    end
  end
  class CriteriaViolation
    include Singleton
    def run(description,value)

    end
  end

  class SomeClass
    def initialize
      array :names do|a|
        a.mutator :add_item,:add_it
        a.new_item_must NotBeJP.instance,CriteriaViolation.instance
        a.new_item_must NotBeNil.instance,CriteriaViolation.instance
      end
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
    def initialize
      array :names do|a|
        a.mutator :add_item
        a.process_using :display_all,DisplayItem
      end
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

    def initialize
      array :names do|a|
        a.mutator :add_item
        a.process_using :display_all,:process #the second symbol is the name of a method on an element in the array
      end
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
