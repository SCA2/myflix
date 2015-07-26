source 'https://rubygems.org'
ruby '2.2.2'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'coffee-rails'
gem 'rails', '4.1.12'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'sidekiq'

group :development do
  gem 'thin', '~> 1.6.3'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem 'fabrication'
  gem 'faker'
  gem 'rspec-rails', '2.99'
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor'
end

