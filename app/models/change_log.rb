#encoding: utf-8
require "model-base"
class ChangeLog
    include DataMapper::Resource
    include Utils::DataMapper::Model
    #extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id        , Serial 
    property :title     , String
    property :content   , Text
    property :source    , String, :default => "web"
    property :author    , String
    property :editor    , String
    property :tag       , String 
    property :duration  , String 
    property :remark    , String

    # instance methods
    def human_name
      "更新记录"
    end
end
