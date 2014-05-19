require 'bundler'
Bundler.require

require "sinatra/reloader" if development? 
require "sinatra/cookies"

require "./config/split"

configure do
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.config'))
end

class MongoHQTour < Sinatra::Base
  enable :sessions
  helpers Split::Helper
  helpers Sinatra::Cookies

  configure :development do
    register Sinatra::Reloader
    also_reload 'config/split'
  end

  configure do
    set :app_file, __FILE__
    set :root, File.dirname(__FILE__)
    set :views, "views"
    set :public_folder, 'static'
  end

  # at a minimum, the main sass file must reside within the ./views directory. here, we create a ./views/stylesheets directory where all of the sass files can safely reside.
  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
  end

  get '/favicon.ico' do
  end

  get '/signup' do
    finished("tour_headline")
    finished("tour_subtitle")

    redirect "https://www.mongohq.com/signup", 301
  end

  get '*' do
    populate_vars params[:splat].first.sub(/^\//, ''), params[:k], params
    slim :index
  end

  # TODO: this stuff will be populated in the database in
  # response to the ad and the keyword
  def populate_vars(advert, keyword, params)
    @title = 'Managed MongoDB with the Experts :: MongoHQ'
    @subtitle = 'We do simple, reliable cloud-based MongoDB hosting.'
    @toptitle = "Instant best practice MongoDB - a head start."
    @features = ['growth', 'speed', 'expert']
    @action_button = "Get your free Mongo Database"
    @mainbody = <<-MARKDOWN
  <h2>MongoHQ Costs Less</h2>
  <p>MongoHQ databases have a significantly lower total cost of ownership than self-hosting. Beyond economies of scale, you're only charged by the size of your database, from free 16 Megabyte shared storage to thousands of dollars for huge dedicated Terabyte clusters -- and everything in between.</p>
  <p>You only pay for what you need, and you can scale up and down whenever you need to. You can deploy dedicated plans to data centers worldwide -- be it US, Ireland, Tokyo or Singapore.</p>
    MARKDOWN
  end
end
