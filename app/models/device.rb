#encoding: utf-8
require "model-base"
class Device 
    include DataMapper::Resource
    include Utils::DataMapper::Model
    #extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id        , Serial 
    property :human     , String # name
    property :uid       , String, :required => true, :unique => true
    property :os        , String # system: android/Iphone os
    property :platform  , String # platform: iphone 6/ xiaomi 1s
    property :simulator , Boolean, :default => false
    property :gesture_password , String

    has n, :device_infoes
    has n, :device_datas
    has n, :weixiner_devices
    #has n, :weixiners, :through => :weixiner_device

    def current_info
      self.device_infoes.last
    end

    # instance methods
    def human_name
      "设备"
    end
end
