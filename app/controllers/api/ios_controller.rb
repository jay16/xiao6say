#encoding: utf-8 
class API::IOSController < API::ApplicationController

  get "/" do
    api_data = ApiData.new({
      :device => params[:device],
      :data   => params[:data]
    })
    status = api_data.save_with_logger
    hash = { code: 1, info: status }
    respond_with_json hash, 200
  end
end
