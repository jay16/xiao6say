#encoding: utf-8 
class Cpanel::HomeController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/home"

  # root page
  get "/" do
    @users     = User.all
    @weixiners = Weixiner.all
    @messages  = Message.all
    @phantoms  = Phantom.all
    @devices = Device.all
    @device_datas = DeviceData.all

    @app_info = read_json_from(Settings.pgyer.cache_file)

    haml :index, layout: :"../layouts/layout"
  end

  get "/refresh_app_info" do
    app_version_info = Pgyer.latest_version_info
    write_json_into(Settings.pgyer.cache_file, app_version_info)

    flash["success"] = "刷新完成."
    redirect to("/")
  end


  get "/store" do
    redirect to("/account/store") if current_user
    @packages = Package.onsale

    haml :store, layout: :"../layouts/layout"
  end

  # redirect to cpanel
  get "/admin" do
    redirect to("/account")
  end

  # redirect
  # login
  get "/login" do
    redirect to("/user/login")
  end
  # register
  get "/register" do
    redirect to("/user/register")
  end
end
