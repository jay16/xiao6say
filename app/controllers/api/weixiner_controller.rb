#encoding: utf-8
class API::WeixinerController < API::ApplicationController

  route :get, :post, "/:weixiner_uid/info" do
    weixiner_uid = params[:weixiner_uid] || "weixiner-uid-not-provided";
    if weixiner = Weixiner.first(uid: weixiner_uid)
      weixiner_info = weixiner.weixiner_info
      hash = {
        code: 1,
        timestamp: Time.now.strftime("%Y-%m-%d %H:%M")
        weixiner_info: {
          nickname: weixiner_info.nickname,
          openid: weixiner_info.openid,
          headimgurl: weixiner_info.headimgurl,
          unionid: weixiner_info.unionid
        }
      }
      respond_with_json hash, 200
    else
      hash = {code: 0, info: "cannot find weixiner(#{weixiner_uid})"}
      respond_with_json hash, 401
    end
  end


  route :get, :post, "/:weixiner_uid/devices" do
    weixiner_uid = params[:weixiner_uid] || "weixiner-uid-not-provided";
    if weixiner = Weixiner.first(uid: weixiner_uid)
      devices = []
      weixiner.devices(delete_status: "normal").each do |device|
        devices.push({ name: device.human, os: device.os, platform: device.platform, uid: device.uid })
      end

      hash = { code: 1, count: devices.count, devices: devices }
      respond_with_json hash, 200
    else
      hash = { code: 0, info: "cannot find weixiner(#{weixiner_uid})" }
      respond_with_json hash, 401
    end
  end

  route :get, :post, "/:weixiner_uid/bind/:device_uid/device" do
    device_uid = params[:device_uid] || "device-uid-not-provided"
    weixiner_uid = params[:weixiner_uid] || "weixiner-uid-not-provided";

    errors = []
    unless device = Device.first(uid: device_uid, delete_status: "normal")
      errors.push("cannot find device(#{device_uid})")
    end
    unless weixiner = Weixiner.first(uid: weixiner_uid)
      errors.push("cannot find weixiner(#{weixiner_uid})")
    end

    if errors.count == 0
      weixiner_device = WeixinerDevice.first_or_create(device_id: device.id, weixiner_id: weixiner.id)
      if weixiner_device.save_with_logger
        hash = { code: 1, info: "bind successfully(#{weixiner_device.id})" }
        respond_with_json hash, 200
      else
        hash = { code: 0, info: weixiner_device.errors.join(",") }
        respond_with_json hash, 424
      end
    else
      hash = { code: 0, info: errors.join(",")}
      respond_with_json hash, 401
    end
  end

  route :get, :post, "/:weixiner_uid/unbind/:device_uid/device" do
    device_uid = params[:device_uid] || "device-uid-not-provided"
    weixiner_uid = params[:weixiner_uid] || "weixiner-uid-not-provided";

    errors = []
    unless device = Device.first(uid: device_uid, delete_status: "normal")
      errors.push("cannot find device(#{device_uid})")
    end
    unless weixiner = Weixiner.first(uid: weixiner_uid)
      errors.push("cannot find weixiner(#{weixiner_uid})")
    end
    unless weixiner_device = WeixinerDevice.first(device_id: device.id, weixiner_id: weixiner.id)
      errors.push("weixiner(#{weixiner_uid}) not bind with device(#{device_uid})")
    end

    if errors.count == 0
      device.soft_destroy
      if device.delete_status == "soft"
        hash = {code: 1, info: "unbind successfully"}
        respond_with_json hash, 200
      else
        hash = {code: 0, info: "unbind failure - #{weixiner_device.errors.join(',')}"}
        respond_with_json hash, 424
      end
    else
      hash = { code: 0, info: errors.join(",") }
      respond_with_json hash, 401
    end

  end
end