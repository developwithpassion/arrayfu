require 'spec_helper'

module ArrayFu
  describe Dsl do
    context "when a criteria is specified" do
      let(:fail_option){fake}
      let(:real_criteria){fake}
      let(:criteria){fake}
      let(:sut){Dsl.new(:name)}
      before (:each) do
        AddCriterion.stub(:new).with(real_criteria,fail_option).and_return(criteria)
      end
      before (:each) do
        sut.new_item_must(real_criteria,fail_option)
      end
      it "should be added to the list of add specifications for the array" do
        sut.criteria[0].should == criteria
      end
    end
    context "when specifying mutators" do
      context "and a singular mutator is specified" do
        let(:mutator){fake}
        let(:name){"sdfsdf"}
        let(:sut){Dsl.new("sdf")}
        before (:each) do
          MutatorDetail.stub(:new).with(name,nil).and_return(mutator)
        end
        before (:each) do
          sut.mutator(name)
        end
        it "should be added to the list of mutators for the list" do
          sut.mutators[0].should == mutator
        end
      end
      context "and a set of mutators are specified" do
        let(:mutator){fake}
        let(:sut){Dsl.new("sdf")}
        before (:each) do
          MutatorDetail.stub(:new).with(:sdf,nil).and_return(mutator)
          MutatorDetail.stub(:new).with(:other,nil).and_return(mutator)
        end
        before (:each) do
          sut.mutator(:sdf,:other)
        end
        it "should add a new mutator for each name specified" do
          sut.mutators.count.should == 2
        end
      end
    end

    context "when a visitor is specified" do
      let(:visitor){fake}
      let(:the_visitor){fake}
      let(:name){"sdfsdf"}
      let(:sut){Dsl.new("sdf")}
      before (:each) do
        VisitorDetail.stub(:new).with(name,the_visitor).and_return(visitor)
      end
      before (:each) do
        sut.process_using(name,the_visitor)
      end
      it "should be added to the list of visitors for the list" do
        sut.visitors[0].should == visitor
      end
    end

    context "when a set of configurators are provided" do
      context "and they are explicit configurators" do
        let(:configurator1){fake}
        let(:configurator2){fake}
        subject{Dsl.new('name')}

        before (:each) do
          def configurator1.respond_to?(name) true end
          def configurator2.respond_to?(name) true end
        end

        before (:each) do
          subject.configure_using configurator1,configurator2
        end

        it "should invoke the configurator with the dsl" do
          configurator1.should have_received(:configure,subject)
          configurator2.should have_received(:configure,subject)
        end
      end

      context "and they are a set of blocks" do
        let(:configurator1){fake}
        let(:configurator2){fake}
        subject{Dsl.new('name')}
        before (:each) do
          @first_ran = false
          @second_ran = false
        end

        before (:each) do
          subject.configure_using lambda{|item| item.should == subject;@first_ran = true},lambda{|item| item.should == subject;@second_ran = true}
        end

        it "should invoke each block with the dsl" do
          @first_ran.should be_true
          @second_ran.should be_true
        end
      end

      context "and they are a mixture of blocks and explicit configurators" do
        let(:configurator1){fake}
        subject{Dsl.new('name')}
        before (:each) do
          @first_ran = false
          def configurator1.respond_to?(name) true end
        end

        before (:each) do
          subject.configure_using lambda{|item| item.should == subject;@first_ran = true},configurator1
        end

        it "should invoke blocks and configurators" do
          @first_ran.should be_true
          configurator1.should have_received(:configure,subject)
        end
      end
      
    end

  end
end
