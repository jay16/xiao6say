﻿#encoding: utf-8 
class UserController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/user"
  set :layout, :"../layouts/layout"

  get "/" do
    redirect "/user/login" unless current_user
    redirect "/cpanel" if current_user and current_user.admin?

    @weixiners = Weixiner.all
    @messages  = Message.all
    @phantoms  = Phantom.all

    haml :index, layout: settings.layout
  end

  # GET /user/login
  get "/login" do
    @user ||= User.new
    @user.email = request.cookies["_email"]

    haml :login, layout: settings.layout
  end

  # POST login /user/login
  post "/login" do
    user = User.first(email: params[:user][:email])
    if user and user.password == md5_key(params[:user][:password])
      response.set_cookie "cookie_user_login_state", {:value=> user.email, :path => "/", :max_age => "2592000"}

      flash[:success] = "登陆成功"
      redirect request.cookies["cookie_before_login_path"] || "/user"
    else
      response.set_cookie "cookie_user_login_state", {:value=> "", :path => "/", :max_age => "2592000"}
      response.set_cookie "_email", {:value=> params[:user][:email], :path => "/", :max_age => "2592000"}

      flash[:warning] = "登陆失败:" + (user ? "密码错误": "用户不存在")
      redirect "/user/login"
    end
  end

  # GET /user/register
  get "/register" do
    @user ||= User.new

    haml :register, layout: :"../layouts/layout"
  end

  # post /user/register
  post "/register" do
    user_params = params[:user]
    user_params.delete(:password_confirmation)
    user_params.delete("password_confirmation")
    user_params[:password] = md5_key(user_params[:password])
    puts user_params
    user = User.new(user_params)

    if user.save
      flash[:success] = "hi %s, 注册成功，请登陆..." % user.name
      redirect "/user/login"
    else
      msg = ["注册失败:"]
      format_dv_errors(user).each_with_index do |hash, index|
        msg.push("%d. %s" % [index+1, hash.to_a.join(": ")])
      end
      flash[:danger] = msg.join("<br>")
      redirect "/user/register"
    end
  end

  # logout
  # delete /user/logout
  get "/logout" do
    response.set_cookie "cookie_user_login_state", {:value=> "", :path => "/", :max_age => "2592000"}
    redirect "/"
  end

  # post /user/check_email_exist
  post "/check_email_exist" do
    user = User.first(email: params[:user][:email])
    res  = { valid: user.nil? }.to_json
    content_type "application/json"
    body res
  end
end
