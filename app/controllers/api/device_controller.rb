#encoding: utf-8 
class API::DeviceController < API::ApplicationController

  route :get, :post, "/" do
    json = params[:device]
    unless json.kind_of?(Hash)
      json = JSON.parse(params[:device])
    end

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

      hash = { code: 1, device_uid: device.uid }
      respond_with_json hash, 200
    else
      puts device.errors.to_s
      hash = { code: 0, device_uid: "error_uid", error: device.errors }
      respond_with_json hash, 401
    end
  end

  # 使用微信关联设备
  route :get, :post, "/:device_uid/data" do
    device = Device.first_or_create(uid: params[:device_uid] || "device-uid-not-provided")

    json = params[:data]
    unless json.kind_of?(Hash)
      json = JSON.parse(params[:data])
    end

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
      hash = { code: 0, info: "error", error: device_data.errors }
      respond_with_json hash, 401
    end
  end

  # 移动设备手势密码锁
  route :get, :post, "/:device_uid/gesture_password/:gesture_password" do
    device = Device.first_or_create(uid: params[:device_uid] || "device-uid-not-provided")
    if params[:gesture_password]
      device.update(gesture_password: params[:gesture_password])

      if device.gesture_password == params[:gesture_password]
        hash = { code: 1, info: device.gesture_password }
        respond_with_json hash, 200
      else
        hash = { code: 0, info: "fail set gesture_password = '#{params[:gesture_password]}'" }
        respond_with_json hash, 200
      end
    else
        hash = { code: 0, info: "please offer gesture password" }
        respond_with_json hash, 401
    end

  end
end
