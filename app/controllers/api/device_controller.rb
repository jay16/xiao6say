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
      hash = { code: 0, info: "error_uid", error: device.errors.inspect.to_s }
      respond_with_json hash, 401
    end
  end

  route :get, :post, "/data" do
    device = Device.first_or_create(uid: params[:uid] || "error_uid")
    json = JSON.parse(params[:data])
    device_data = device.device_datas.new({
      :input  => json["input"],
      :remain => json["szRemain"],
      :type   => json["szType"],
      :money  => json["nMoney"],
      :time   => json["nTime"],
      :simulator => device.simulator
    })
    if device_data.save_with_logger
      hash = { code: 1, info: device_data.id }
      respond_with_json hash, 200
    else
      hash = { code: 0, info: "error", error: device_data.errors.inspect.to_s }
      respond_with_json hash, 401
    end
  end
end
