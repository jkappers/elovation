source "https://rubygems.org"

gem 'rails', '3.2.11'
gem 'mysql2'
gem 'json', '1.7.5'
gem 'jquery-rails', '2.1.2'
gem 'dynamic_form', '1.1.4'
gem 'elo', '0.1.0'
gem 'trueskill', :git => 'git://github.com/saulabs/trueskill.git', :require => "saulabs/trueskill"
gem 'params_cleaner', '0.4.2'
gem 'devise', '~> 3.2.2'
gem 'cancan', '~> 1.6.10'
gem 'gravtastic'
gem 'urbanairship'
gem 'jbuilder', '~> 1.5.3'
gem 'compass-rails'
gem 'debugger'

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.3.0'
end

group :development do
  gem "better_errors", "~> 0.9.0"
  gem "binding_of_caller", "~> 0.7.2"
end

group :test, :development do
  gem 'rake_commit', '0.13.0'
  gem 'heroku', '2.31.4'
  gem 'timecop', '0.5.2'
  gem 'taps', '0.3.24'
end

group :production do
  gem 'rails_12factor'
end

ruby "1.9.3"