require 'fileutils'
require 'fakes-rspec'
require 'singleton'
require 'rspec'

include RSpec::Matchers

Dir.chdir(File.join(File.dirname(__FILE__),"..,lib".split(','))) do
  require 'arrayfu.rb'
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
