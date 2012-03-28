require 'fileutils'
require 'fakes-rspec'
require 'singleton'

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

