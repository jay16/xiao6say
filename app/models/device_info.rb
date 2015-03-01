#encoding: utf-8
require "model-base"
class DeviceInfo
    include DataMapper::Resource
    include Utils::DataMapper::Model
    #extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id        , Serial 
    property :json      , Text

    belongs_to :device

    # instance methods
    def human_name
      "设备信息"
    end
end
