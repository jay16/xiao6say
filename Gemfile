#encoding: utf-8
source "https://ruby.taobao.org"
#source "http://gemcutter.org"

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

gem "sinatra", "~>1.4.5"
gem "sinatra-contrib", "~>1.4.2"
gem "sinatra-flash", "~>0.3.0"
#gem 'sinatra-assetpack', "~>0.3.3", :require => 'sinatra/assetpack'

gem "actionmailer"
gem "warden", "~>1.2.3"
gem "sinatra_more", "~>0.3.43"
#gem "sinatra-advanced-routes", :require => "sinatra/advanced_routes"
#gem "sinatra-logger", "~>0.1.1"
# This project is now part of sinatra-contrib.
# gem "sinatra-reloader" 

#db
gem "dm-core", "~>1.2.1"
gem "dm-migrations", "~>1.2.0"
gem "dm-validations", "~>1.2.0"
gem "dm-aggregates", "~>1.2.0"
gem "dm-timestamps", "~>1.2.0"
gem "dm-sqlite-adapter", "~>1.2.0"

#assets
gem "rake", "~>10.3.2"
gem "json", "~>1.8.1"
gem "haml", "~> 4.0.5"
gem "sass", "~>3.3.7"
gem "therubyracer", "~>0.12.1"
gem "coffee-script", "~>2.2.0"
gem 'will_paginate', '~> 3.0.6'
gem "will_paginate-bootstrap", "~>1.0.1"

gem "unicorn", "~>4.8.3"
gem "settingslogic", "~>2.0.9"
#gem "rest-client", "~>1.7.2"
gem "httparty", "~>0.13.3"
gem "ruby-pinyin", "~>0.4.5"

group :development do
  gem "net-ssh", "~>2.7.0"
  gem "net-scp", "~>1.2.1"
end
group :test do
  gem "rack-test", "~>0.6.2"
  gem "rspec", "~>2.14.1"
end
