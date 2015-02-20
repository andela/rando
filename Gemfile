source 'https://rubygems.org'
ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Bootstrap SASS for other stylesheets
gem 'bootstrap-sass', '~> 3.3.3'
gem 'autoprefixer-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

#Use Figaro to store environment secrets
gem 'figaro'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'

#For view decoration
gem 'draper', '~> 1.3'

#Use for picking date
gem 'pickadate-rails'

#Use jquery-turbolinks for jquery date-picker
gem 'jquery-turbolinks'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  #Use Factory Girl for test fixtures
  gem 'factory_girl_rails', '~> 4.0'

  #Use shoulda-matchers for Rspec validations
  gem 'shoulda-matchers'

  #To open a file(snapshot) automaitcally
  gem 'launchy'

end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'

end

group :production do
  #Rails 4 Asset Pipeline on Heroku. Serve static assets
  gem 'rails_12factor'
end

#Use Puma web server for Heroku deployment
gem 'puma'