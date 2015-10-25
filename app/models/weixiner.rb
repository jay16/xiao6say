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
    has n, :weixiner_devices
    has n, :devices, :through => :weixiner_devices
    has 1, :weixiner_info

    def head_img_url
      default_headimgurl = "/images/headimgurl.jpeg"
      headimgurl = self.weixiner_info.headimgurl.strip rescue default_headimgurl
      headimgurl.empty? ? default_headimgurl : headimgurl
    end

    def nick_name
      self.weixiner_info.nickname rescue "TODO"
    end

    def sex
      self.weixiner_info.sex == 1 ? "男" : "女"
    end

    def area
      weixiner_info = self.weixiner_info
      [weixiner_info.country, weixiner_info.province, weixiner_info.city]
      .find_all { |item| !item.nil? and item.length > 0 }
      .join("/")
    end

    def personal_report
      _messages = self.messages
      report = "个人统计"
      report << "\n微信消息: %d" % _messages.count rescue 0
      report << "\n微信例句: %d" % _messages.find_all { |m| m.phantom }.count rescue 0
      report << "\n绑定设备: %d" % self.devices.count
      report << "\n设备例句: %d" % self.devices.inject(0) {|sum, device| sum += device.device_datas.count }
      report << "\n再次感谢您的贡献/::P"
    end

    # instance methods
    def human_name
      "微信用户"
    end
end
