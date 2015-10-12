#encoding: utf-8 
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"
  set :layout, :"../layouts/layout"

  # root page
  get "/" do
    redirect "/user" if current_user
    #@weixiners = Weixiner.all
    #@messages  = Message.all
    #@phantoms  = Phantom.all
    #@devices   = Device.all#(:simulator => false)
    #@datas     = DeviceData.all#(:simulator => false)

    haml :index#, layout: settings.layout
  end

  get "/about" do
    cache_file   = File.join(ENV["APP_ROOT_PATH"], "tmp/weixin_menu_view.cache")
    expired_file = cache_file + ".expired"
    if File.exist?(cache_file)
      expired_lines = IO.readlines(expired_file) rescue []
      cache_lines   = IO.readlines(cache_file) - expired_lines
      unless cache_lines.empty?
        line = cache_lines.last
        timestamp, from_user_name = line.split(/,/)
        if Time.now.to_i - timestamp.to_i <= 1
          @from_user_name = from_user_name
          `echo '#{line}' >> #{expired_file}`
          `grep -vFf #{expired_file} #{cache_file} > #{cache_file}` 
          `true > #{expired_file}`
        else
          `true > #{cache_file}`
          puts "Weixin Menu View Expired! - %s" % line
        end
      end
    end
    haml :about, layout: settings.layout
  end

  get "/change_log" do
    @change_logs = ChangeLog.all(publish: true, order: [:created_at.desc])

    haml :change_log, layout: settings.layout
  end

  # redirect to cpanel
  get "/admin" do
    redirect "/cpanel"
  end

  # redirect
  # login
  get "/login" do
    redirect "/user/login"
  end
  # register
  get "/register" do
    redirect "/user/register"
  end
end
