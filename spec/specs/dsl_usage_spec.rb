require 'spec_helper'

module ArrayFu
  describe Dsl do
    context "using the dsl" do
      it "should be able to initialize all arrays specified on the instance and provide a method to expose addition" do
        class Item

          def initialize
            array :kids do|a|
              a.mutator :register_child 
            end
          end
        end

        item = Item.new
        item.methods.include?(:register_child).should be_true
        item.register_child("hello")
        item.kids.count.should == 1
      end
      it "should be able to expose a mutator with custom logic" do
        class Item
          attr_accessor :added,:item_added

          def initialize
            @added = 0

            array :kids do|a|
              a.mutator :register_child do|the_item|
                @item_added = the_item
                @added +=1
                @kids.push(the_item)
              end
            end
          end
        end

        item = Item.new
        item.register_child("hello")
        item.kids.count.should == 1
        item.item_added.should == "hello"
        item.added.should == 1
      end

      it "should be able to expose a processing visitor" do
        class Item
          attr_accessor :added

          def initialize(visitor)
            @added = 0
            array :kids do|a|
              a.mutator :register_child
              a.process_using :register_kids,visitor
            end
          end
        end

        class OurVisitor
          attr_accessor :items
          def initialize
            @items = 0
          end
          def run_using(item)
            @items +=1
          end
        end

        our_visitor = OurVisitor.new
        item = Item.new(our_visitor)
        item.register_child("hello")
        item.kids.count.should == 1
        item.register_kids
        our_visitor.items.should == 1
      end

      it "should be able to expose a processing visitor by symbol" do
        class Item
          attr_accessor :added

          def initialize
            @added = 0
            array :kids do|a|
              a.mutator :register_child
              a.process_using :register_kids,:speak
            end
          end
        end

        class Kid
          def initialize(array)
            @array = array
          end
          def speak
            @array.push("spoke")
          end
        end

        items = []
        item = Item.new
        item.register_child(Kid.new(items))
        item.kids.count.should == 1
        item.register_kids
        items.count.should == 1
      end
    end

    context "when specifying a mutator" do
      context "and no block is provided" do
        it "should expose the specified method to trigger addition" do
          class Item

            def initialize
              array :kids do|a|
                a.mutator :register_child
              end
            end
          end

          item = Item.new
          item.methods.include?(:register_child).should be_true
          item.register_child("hello")
          item.kids.count.should == 1
        end
      end

      context "and a block is provided" do
        it "should provide a method that delegates to the block when invoked" do
          class Item
            attr_accessor :added

            def initialize
              @added = 0

              array :kids do|a|
                a.mutator :register_child do|item|
                  @kids.push(item)
                  @added+=1
                end
              end
            end
          end

          item = Item.new
          item.register_child("hello")
          item.kids.count.should == 1
          item.added.should == 1
        end
      end


      context "when criterias have been specified on the array" do
        class BeGreaterThanZero
          def name
            return "Be greater than 0"
          end
          def is_satisfied_by(item)
            return item > 0
          end
        end
        context "and the criteria is not met" do
          context "and the failure strategy is set to raise an error" do
            class RaiseCriteriaFailure
              def run(name,value)
                raise "The value #{value} does not meet the criteria #{name}"
              end
            end
            class OneClass
              def initialize
                array :items do|a|
                  a.mutator :add_item,:add_this,:add_that
                  a.new_item_must BeGreaterThanZero.new, RaiseCriteriaFailure.new
                end
              end
            end
            let(:target){OneClass.new}
            before (:each) do
              @exception = catch_exception do
                target.add_item(0)
              end
            end

            it "should raise an error when a failed add is attempted" do
              (@exception.message =~ /does not meet/).should be_true
            end
            it "should not add the item to the underlying list" do
              target.items.count.should == 0
            end
          end

          context "and the failure strategy is not set to raise an error" do
            class DisplayCriteriaFailure
              include Singleton
              attr_accessor :message
              def run(name,value)
                @message = "The value #{value} does not meet the criteria #{name}"
              end
            end
            class AnotherClass
              def initialize
                array :items do|a|
                  a.mutator :add_item,:add_this,:add_that
                  a.new_item_must BeGreaterThanZero.new, DisplayCriteriaFailure.instance
                end
              end
            end
            let(:target){AnotherClass.new}
            before (:each) do
              target.add_item(0)
            end
            it "should have leveraged the failure strategy that does not throw an exception" do
              DisplayCriteriaFailure.instance.message.should_not be_nil
            end

            it "should not add the item to the underlying list" do
              target.items.count.should == 0
            end
          end
        end
      end
    end
  end
end
