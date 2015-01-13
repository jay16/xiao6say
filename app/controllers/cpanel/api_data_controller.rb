#encoding: utf-8 
class Cpanel::APIDataController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/api_data"
  set :layout, :"../layouts/layout"

  get "/" do
    @api_datas = ApiData.all(:order => :created_at.desc)

    haml :index, layout: settings.layout
  end
end
