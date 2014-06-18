require 'spec_helper'

module ArrayFu
  describe GenerateWriters do
    context "when run" do
      context "using a dsl fragment that contains no block usage" do
        let(:target){Sample.new}
        let(:mutators){[]}
        let(:sut){GenerateWriters}
        let(:builder){ArrayDefinition.new(:numbers)}
        before (:each) do
          builder.writeable
        end
        before (:each) do
          target.extend(sut.create_using(builder))
        end
        it "should create a member on the target that allows assignment to the array" do
          new_array = [1]
          target.numbers = new_array
          def target.numbers
            return @numbers
          end
          target.numbers.should == new_array
        end
      end
    end
  end
end
