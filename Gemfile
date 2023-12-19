source 'https://rubygems.org'

ruby '3.1.2'

gem 'rails', '~> 7.1.2'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'bcrypt', '~> 3.1.7'
gem 'tzinfo-data', platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem 'bootsnap', require: false
gem 'faraday'
gem 'ipaddress', '~> 0.8.3'
gem 'alba'
gem 'oj'
gem 'pundit'
gem 'dry-validation'

group :development, :test do
  gem 'debug', platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
  gem 'rspec-rails', '~> 5.0'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
  gem 'annotate'
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov', require: false
end
