#encoding: utf-8 
class Cpanel::WeixinersController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/weixiners"
  set :layout, :"../layouts/layout"

  # root page
  get "/" do
    @weixiners = Weixiner.all

    haml :index, layout: settings.layout
  end
end
