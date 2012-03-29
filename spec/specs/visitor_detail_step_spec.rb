require 'spec_helper'

module ArrayFu
  describe VisitorDetailStep do
    class OurSet
      attr_accessor :items

      def initialize
        @items = []
      end

      def add(item)
        @items << item
      end
    end
    class Speak
      def initialize(invocations)
        @invocations = invocations
      end
      def hello
        @invocations.push(1)
      end
    end
    context "when run" do
      context "using a visitor that is symbol based" do
        let(:target){OurSet.new}
        let(:mutators){[]}
        let(:invocations){[]}
        let(:sut){VisitorDetailStep.new}
        let(:builder){Dsl.new(:items)}
        before (:each) do
          (1..10).each{|item| target.add(Speak.new(invocations))}
          builder.process_using(:run,:hello)
        end
        before (:each) do
          target.extend(sut.create_using(builder))
        end

        it "should create a method on the target that triggers each item in the list using its provided action" do
          target.run
          invocations.count.should == 10
        end
      end
      context "using a visitor that is class based" do
        class TheVisitor
          attr_accessor :items
          def initialize
            @items = []
          end
          def run_using(item)
            @items << item
          end
        end
        let(:target){OurSet.new}
        let(:visitor){TheVisitor.new}
        let(:mutators){[]}
        let(:invocations){[]}
        let(:sut){VisitorDetailStep.new}
        let(:builder){Dsl.new(:items)}

        before (:each) do
          (1..10).each{|item| target.add(item)}
          builder.process_using(:run,visitor)
        end
        before (:each) do
          target.extend(sut.create_using(builder))
        end

        it "should create a method on the target that triggers the visitor once for each item in the list" do
          target.run
          (1..10).each{|item| visitor.items.include?(item).should be_true}
        end
      end
    end
  end
end
