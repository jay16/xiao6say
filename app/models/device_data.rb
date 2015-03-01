#encoding: utf-8
require "model-base"
class DeviceData
    include DataMapper::Resource
    include Utils::DataMapper::Model
    #extend  Utils::DataMapper::Model

    property :id        , Serial 
    property :input     , Text
    property :remain    , String
    property :type      , String
    property :money     , String
    property :time      , String
    property :simulator , Boolean , :default => false

    belongs_to :device

    # ins1tance methods
    def human_name
      "设备数据"
    end
end
