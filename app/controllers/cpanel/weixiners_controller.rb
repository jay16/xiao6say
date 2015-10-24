#encoding: utf-8 
class Cpanel::WeixinersController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/weixiners"
  set :layout, :"../layouts/layout"
  include WillPaginate::Sinatra::Helpers

  # root page
  get "/" do
    @weixiners = Weixiner.paginate(:page => params[:page], :per_page => 15)

    haml :index, layout: settings.layout
  end
end
