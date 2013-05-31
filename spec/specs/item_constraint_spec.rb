require 'spec_helper'

module ArrayFu
  describe ItemConstraint do
    context "when applied to a value" do
      let(:failure_strategy){fake}
      let(:constraint){fake}
      let(:value){42}
      let(:name){"Name of constraint"}
      let(:sut){ItemConstraint.new(constraint, failure_strategy)}

      context "and the value does not match the constraint" do
        before (:each) do
          constraint.stub(:matches?).with(value).and_return(false)
          constraint.stub(:name).and_return(name)
        end
        before (:each) do
          sut.apply_to(value)
        end
        it "should run the failure strategy with the correct information" do
          failure_strategy.should have_received(:run, name, value)
        end
      end

      context "and the value matches the constraint" do
        before (:each) do
          constraint.stub(:matches?).with(value).and_return(true)
          constraint.stub(:name).and_return(name)
        end
        before (:each) do
          @result = sut.apply_to(value)
        end
        it "should not use the failure strategy" do
          failure_strategy.should_not have_received(:run)
        end
        it "should return true" do
          @result.should be_true
        end
      end
    end
  end
end
