require 'rspec'
require 'fileutils'
require 'developwithpassion_fakes'

Dir.chdir(File.join(File.dirname(__FILE__),"..,lib".split(','))) do
  Dir.glob("**/*.rb").each do |file| 
    full_path = File.expand_path(file)
    $:.unshift File.expand_path(File.dirname(full_path))
    require full_path
  end
end

def fake
  DevelopWithPassion::Fakes::Fake.new
end

def catch_exception
  begin
    yield
  rescue Exception => e
    exception = e
  end
  exception
end

module RSpec
  Matchers.define :have_received do|symbol,*args|
    match do|fake|
      fake.received(symbol).called_with(*args) != nil
    end
  end

  Matchers.define :never_receive do|symbol,*args|
    match do|fake|
      item = fake.received(symbol)
      result = true
      if (item == nil)
        result = (args.count == 0)
      else
        result = (item.called_with(*args) == nil)
      end
      result
    end
  end
end
