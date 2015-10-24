#encoding: utf-8
require "model-base"
class WeixinerDevice
  include DataMapper::Resource
  include Utils::DataMapper::Model
  #extend Utils::DataMapper::Model
  #include Utils::ActionLogger

  property :id, Serial

  belongs_to :device
  belongs_to :weixiner

  def human_name
    "微信-设备"
  end
end