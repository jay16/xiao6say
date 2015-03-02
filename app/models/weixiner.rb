#encoding: utf-8
require "model-base"
class Weixiner
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id  , Serial 
    # 微信名称
    property :uid,    String, :required => true, :unique => true
    property :status, String, :default => "subscribe"

    has n, :messages # 微信消息
    has 1, :weixiner_info

    def head_img_url
      default_headimgurl = "/images/headimgurl.jpeg"
      headimgurl = self.weixiner_info.headimgurl.strip rescue default_headimgurl
      headimgurl.empty? ? default_headimgurl : headimgurl
    end

    def nick_name
      self.weixiner_info.nickname rescue "TODO"
    end

    def personal_report
      _messages = self.messages
      report = "个人统计"
      report << "\n消息数量: %d" % _messages.count rescue 0
      report << "\n例句数量: %d" % _messages.find_all { |m| m.phantom }.count rescue 0
      report << "\n例句判断: %d" % _messages.find_all { |m| m.phantom }.find_all { |m| !m.phantom.yn.empty? }.count rescue 0
      report << "\n再次感谢您的贡献/::P"
    end

    # instance methods
    def human_name
      "微信用户"
    end
end
