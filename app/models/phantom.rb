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

    def process
      result = ""
      begin
        hash = ::JSON.parse(self.json) 
      rescue => e
        puts e.message
        hash = {error: "json error"}
      end
      hash.each_pair do |key, value|
        result += "%s: %s\n" % [key, value]
      end
      result += "\n请输入0(错误)或1(正确)对解析结果判断."
      return result
    end

    def style
      case self.yn
      when "1" then "success"
      when "0" then "danger"
      else "warning"
      end
    end

    # instance methods
    def human_name
      "解析结果"
    end
end
