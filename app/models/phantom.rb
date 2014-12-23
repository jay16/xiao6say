#encoding: utf-8
require "model-base"
class Phantom 
    include DataMapper::Resource
    include Utils::DataMapper::Model
    #extend  Utils::DataMapper::Model

    property :id        , Serial 
    property :raw_text  , Text    , :required => true
    property :json      , Text
    property :yn        , String  , :default => ""

    belongs_to :message, :required => false

    # instance methods
    def human_name
      "解析结果"
    end
end
