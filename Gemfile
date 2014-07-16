source "https://rubygems.org"

gem 'rake', '>= 0.9'
gem 'rdoc', '>= 3.9'

group :development do
 gem 'guard', '~> 2.6.1'
 gem 'guard-rspec', '~> 4.2.9'
 gem 'yard', '~> 0.8.7.4'
 gem 'thor', '>= 0.19.1'
end

group :test do
  gem 'fakes-rspec', '~> 2.0.0'
  gem 'rest-client', '~> 1.6.0', platforms: [:jruby, :ruby_18]
  gem 'coveralls', '>= 0.5.7', require: false
end

gemspec
