#encoding: utf-8 
class Cpanel::PhantomsController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/phantoms"
  set :layout, :"../layouts/layout"
  helpers PhantomHelper

  # root page
  get "/" do
    @phantoms = Phantom.all

    haml :index, layout: settings.layout
  end

  get "/export" do
    yn = @params[:yn] || "111"
    @phantoms = Phantom.all
    @phantoms = @phantoms.find_all { |p| p.yn != "1" } if yn[0] == "0"
    @phantoms = @phantoms.find_all { |p| p.yn != "0" } if yn[1] == "0"
    @phantoms = @phantoms.find_all { |p| p.yn != "" }  if yn[2] == "0"
    timestamp = Time.now.strftime("%y%m%d%H%M%S")
    filename = "export_%s_%s.txt" % [timestamp, yn]
    filepath = File.join(ENV["APP_ROOT_PATH"], "tmp", filename)
    File.open(filepath, "a+") do |file|
      @phantoms.each do |phantom|
        file.puts phantom.raw_text
      end
    end
    send_file(filepath, filename: filename)
  end

  # call C process Text
  post "/process" do
    phantom = Phantom.first(id: @params[:id])
    phantom.raw_text.process_pattern[1] rescue '{"error": "脚本错误"}'
  end

  post "/" do
    phantom = Phantom.first(id: @params[:id])
    phantom.update(@params[:phantom])
    redirect "/cpanel/phantoms#%d" % phantom.id
  end
end
