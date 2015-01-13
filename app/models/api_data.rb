#encoding: utf-8
require "model-base"
class ApiData
    include DataMapper::Resource
    include Utils::DataMapper::Model
    #extend  Utils::DataMapper::Model

    property :id        , Serial 
    property :device    , Text
    property :data      , Text

    # ins1tance methods
    def human_name
      "api数据"
    end
end
