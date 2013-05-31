require 'spec_helper'

module ArrayFu
  describe GenerateMutators do
    context "when run" do
      let(:numbers){[]}
      let(:target){Sample.new(numbers)}
      let(:mutators){[]}
      let(:sut){GenerateMutators}
      let(:builder){ArrayDefinition.new(:numbers)}

      context "using a dsl fragment that contains no block usage" do
        before (:each) do
          builder.mutator(:add_a_number)
        end
        before (:each) do
          target.extend(sut.create_using(builder))
        end
        it "should create a member on the target that allows mutation of the original list" do
          target.respond_to?(:add_a_number).should be_true
          target.add_a_number(2)
          numbers[0].should == 2
        end
      end
      context "using a dsl fragment that contains block usage" do
        before (:each) do
          builder.mutator :add_a_number do|value|
            @value_attempted_to_be_added = value
          end
        end
        before (:each) do
          target.extend(sut.create_using(builder))
        end
        it "should create a member on the target that intercepts mutation using the provided block" do
          target.respond_to?(:add_a_number).should be_true
          target.add_a_number(2)
          numbers.count.should == 0
          target.value_attempted_to_be_added.should == 2
        end
      end

    end

  end
end
