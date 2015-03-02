#encoding: utf-8 
class Cpanel::DevicesController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/devices"
  set :layout, :"../layouts/layout"

  get "/" do
    @devices = Device.all
    @device_datas = DeviceData.all

    haml :index, layout: settings.layout
  end
end
