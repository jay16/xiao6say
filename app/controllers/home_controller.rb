#encoding: utf-8 
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"
  set :layout, :"../layouts/layout"

  # root page
  get "/" do
    redirect "/user" if current_user
    @weixiners = Weixiner.all
    @messages  = Message.all
    @phantoms  = Phantom.all

    haml :index, layout: settings.layout
  end

  get "/about" do
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
