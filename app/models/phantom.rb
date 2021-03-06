﻿#encoding: utf-8
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
        next if ["分钟", "金额"].include?(key) and value.to_i == 0

        result += "%s: %s\n" % [key, value] 
      end
      result += "\n请输入[1正确/(其他值)错误 空格 意见反馈]"
      return result
    end

    def style
      case self.yn
      when "1" then "success"
      when "0" then "danger"
      else "warning"
      end
    end

    def yn_human
      case self.yn
      when "1" then "正确"
      when "0" then "错误"
      else "未决"
      end
    end

    # ins1tance methods
    def human_name
      "解析结果"
    end
end
