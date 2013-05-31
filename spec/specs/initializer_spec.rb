require 'spec_helper'

describe ArrayFu::Initializer do
  context "when initializing fields with defaults" do
    it "should initialize based on the factory provided" do
      class Item
        include ArrayFu::Initializer
        attr_accessor :kids,:cars,:name

        def initialize
          initialize_defaults lambda{[]},:kids,:cars
          initialize_defaults lambda{""},:name
        end
      end

      item = Item.new
      [item.kids,item.cars].each{|value| value.class.should == Array}
      item.name.class.should == String
    end
  end

  context "when initializing simple arrays" do
    it "should initialize all arrays specified on the instance" do
      class Item
        include ArrayFu::Initializer
        attr_accessor :kids,:cars,:bikes

        def initialize
          initialize_arrays :kids,:cars,:bikes
        end
      end

      item = Item.new
      [item.kids,item.cars,item.bikes].each do|value| 
        value.class.should == Array
      end
    end
  end

  context "when initializing hashes" do
    it "should initialize all hashes specified" do
      class Item
        include ArrayFu::Initializer
        attr_accessor :kids,:cars,:bikes

        def initialize
          initialize_hashes :kids,:cars,:bikes
        end
      end

      item = Item.new
      [item.kids,item.cars,item.bikes].each do|value| 
        value.class.should == Hash
      end
    end
  end
end

