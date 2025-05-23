# config.ru
require './app'
run Sinatra::Application

# tells Rack (used by Render and other servers) how to start your app