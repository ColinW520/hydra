source 'https://rubygems.org'

# Core Stuff
ruby '2.3.2'
gem 'rails', '~> 5.0.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Font End Stuff
gem 'bootstrap', '~> 4.0.0.alpha3'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end
gem 'turbolinks', '~> 5'
gem 'puma', '~> 3.0'
gem 'haml-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'chartkick'
gem 'groupdate'
gem 'smart_listing', github: 'ColinW520/smart_listing'
gem 'gon'

# Database Stuff
gem 'pg', '~> 0.18'
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'

# Background Stuff
# gem 'redis', '~> 3.0'

# Third Party Stuff
gem "twilio-ruby"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'html2haml'
  gem 'erb2haml'
  gem 'mailcatcher'
end
