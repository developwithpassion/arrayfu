require 'fileutils'
require 'developwithpassion_fakes-rspec'

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

