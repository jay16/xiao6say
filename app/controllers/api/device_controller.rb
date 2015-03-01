#encoding: utf-8 
require "json"
class API::DeviceController < API::ApplicationController

  route :get, :post, "/" do
    json = JSON.parse(params[:device])
    device_name     = json["name"].strip
    device_id       = json["id"].strip
    device_os       = json["os"].strip
    device_platform = json["platform"].strip
    device_uid      = md5_key("%s#%s" % [device_id, device_platform])

    unless device = Device.first(:uid => device_uid)
      device = Device.new({
        :human     => device_name,
        :uid       => device_uid,
        :os        => device_os,
        :platform  => device_platform,
        :simulator => device_platform.downcase.include?("simulator")
      })
    end
    if device.save_with_logger
      device_info = device.device_infoes.new(json: params[:device])
      device_info.save_with_logger

      hash = { code: 1, info: device.uid }
      respond_with_json hash, 200
    else
      puts device.errors.to_s
      hash = { code: 0, info: device.errors.inspect.to_s }
      respond_with_json hash, 401
    end
  end

  route :get, :post, "/data" do
  end
end
