#encoding: utf-8
require "model-base"
class Message # 微信消息
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model

    property :id             , Serial 
    property :msg_type       , String  , :required => true
    property :raw_message    , Text    , :required => true
    property :to_user_name   , String  , :required => true
    property :from_user_name , String  , :required => true
    # debug it without below two
    property :create_time    , String#  , :required => true
    property :msg_id         , String#  , :required => true
    # voice
    property :media_id       , Text
    property :format         , String
    property :recognition    , Text
    # text
    property :content        , Text
    # image
    property :pic_url        , Text
    # location
    property :location_x     , String
    property :location_y     , String
    property :scale          , String
    property :label          , String
    # link
    property :title          , String
    property :description    , Text
    property :url            , Text
    # event
    property :event          , String
    property :event_key      , String
    property :latitude       , String
    property :precision      , String

    # 响应内容 - 自定义
    property :response       , Text

    belongs_to :weixiner, :required => false
    has 1, :phantom

    after :save do |message|
      # 语音文字 => 词义解析 
      recognition = message.recognition.force_encoding("UTF-8")
      # recognition = "学习英语四十分钟"
      # recognition = "功能添加 更新日志 一个半小时"
      puts message.from_user_name
      if message.msg_type == "voice" and recognition.length > 0
        result = recognition.process_pattern rescue [false, '{"error": "执行失败"}']
        phantom = Phantom.new({
          :message_id => message.id,
          :raw_text   => recognition,
          :json       => result[0] ? result[1] : '{"error": "脚本错误"}'
        })
        phantom.save_with_logger

        # create change_log through weixin
        admin_group = {
          "DxaRTPM72HgjY9zo8kyntqSXF3fc" => "wechat",
          "oH4gjt9zVQeIt1ZUdngMkKdIhw7k" => "junjie",
          "oH4gjt1g0GwyO7whiVhnp7WUHEiY" => "albert",
          "oH4gjt1tmo0C1ia7g4-Sey81W2ZY" => "herman",
          "oH4gjt_Q7UBeNpeCoUQI5Rgi3a9g" => "phantom"
        }
        if admin_group.keys.include?(message.from_user_name)
          keywords = %w[会议记录 功能添加 功能调整 界面优化 代码优化]
          if keyword = keywords.find { |k| recognition.start_with?(k) }
            change_log = ChangeLog.new({
              title: "%s#%s" % [keyword, Time.now.strftime("%y/%m/%d %H:%M")],
              content: recognition,
              tag: keyword,
              source: "weixin",
              author: admin_group.fetch(message.from_user_name),
              remark: "message#%d" % message.id
            })
            change_log.save_with_logger
          end
        end
      end
    end

    # instance methods
    def human_name
      "微信消息"
    end
end
