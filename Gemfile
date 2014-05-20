source "https://rubygems.org"

group :app do

    # app service
    gem 'rack'
    gem 'thin'
    gem 'sinatra', :require => 'sinatra/base'
    gem 'sinatra-contrib'
    gem 'sprockets'
    gem 'sprockets-helpers'

    # websocket
    gem 'eventmachine'
    gem 'em-websocket', '0.3.8'

    # utils
    gem 'browser'

    # templates and compiler
    gem 'erubis'
    gem 'haml'
    gem 'coffee-script'
    gem 'sass'
    gem 'compass'
    gem 'uglifier'

    # database
    gem "activerecord"
    gem "sinatra-activerecord"
    gem "sqlite3"
end

group :production do

end

group :development do
    gem 'better_errors'
    gem 'binding_of_caller'
end

group :test do
    gem "rspec"
end

