require 'spec_helper'

module ArrayFu
  describe GenerateReaders do
    context "when run" do
      let(:target){Sample.new}
      let(:mutators){[]}
      let(:sut){GenerateReaders}
      let(:builder){ArrayDefinition.new(:numbers)}

      context "using a dsl fragment that contains no block usage" do
        before (:each) do
          builder.readable
        end
        before (:each) do
          target.extend(sut.create_using(builder))
        end
        it "should create a member on the target that allows reading of the array" do
          target.numbers.should be_a(Array)
        end
      end
    end
  end
end
