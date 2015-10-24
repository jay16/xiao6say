#encoding: utf-8 
class Cpanel::DevicesController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/devices"
  set :layout, :"../layouts/layout"
  include WillPaginate::Sinatra::Helpers

  get "/" do
    @devices = Device.paginate(:page => params[:page], :per_page => 15)

    haml :index, layout: settings.layout
  end

  get "/datas" do
    @datas = DeviceData.all(:order => [:id.desc]).paginate(:page => params[:page], :per_page => 30)

    haml :datas, layout: settings.layout
  end
end
