source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use Devise for User authentication
gem 'devise', '~> 4.3.0'

# Token based authentication
gem 'doorkeeper'

# Use HTTParty to curl external APIs
gem 'httparty', '~> 0.14.0'

# Soft delete
gem 'paranoia', '~> 2.2'

# JSON serialization
gem 'active_model_serializers'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Linters
  gem 'flay'
  gem 'flog'
  gem 'rails_best_practices', '~> 1.18.0'
  gem 'reek', '~> 4.6.1'
  gem 'rubocop', '~> 0.48.1'
  gem 'brakeman', '~> 3.7.0'

  # Testing
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem "codeclimate-test-reporter", "~> 1.0.0", require: false
  gem 'factory_girl_rails'
  gem 'faker'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
