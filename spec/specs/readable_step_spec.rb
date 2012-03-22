require 'spec_helper'

module DevelopWithPassion
  module Arrays
    describe ReadableStep do
      context "when run" do
        let(:target){Sample.new}
        let(:mutators){[]}
        let(:sut){ReadableStep.new}
        let(:builder){Dsl.new(:numbers)}

        context "using a dsl fragment that contains no block usage" do
          before (:each) do
            builder.readable
          end
          before (:each) do
            target.extend(sut.run_using(builder))
          end
          it "should create a member on the target that allows reading of the array" do
            target.numbers.should be_a(Array)
          end
        end
      end
    end
  end
end
