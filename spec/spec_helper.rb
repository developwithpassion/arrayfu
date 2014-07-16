require 'coveralls'
Coveralls.wear!

require 'fileutils'
require 'fakes-rspec'
require 'singleton'
require 'rspec'

include RSpec::Matchers

Dir.chdir(File.join(File.dirname(__FILE__),"..,lib".split(','))) do
  require 'arrayfu.rb'
end

class Sample
  attr_reader :value_attempted_to_be_added

  def initialize(numbers = [])
    @numbers = numbers
  end
end


def catch_exception
  begin
    yield
  rescue Exception => e
    exception = e
  end
  exception
end

def example name,&block
  describe "Example:" do
    it name do
      yield
    end
  end
end
