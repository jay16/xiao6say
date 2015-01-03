#encoding: utf-8
require "erb"
require "json"

module Sinatra
  module ReplyRobot 
    # command parser
    class Command 
      attr_reader :key, :command, :raw_cmd, :exec_cmd
      def initialize(message)
        @message  = message
        @result   = []
        @raw_cmd  = message.content 
      end
      def self.exec(raw_cmd)
        reply = new(raw_cmd)
        reply.handler
      end
      def handler
        if @raw_cmd =~ /^\?/ or @raw_cmd.force_encoding('UTF-8').start_with?("？")
            help
        else
          voice = @message.weixiner.messages.last(:msg_type => "voice")
          if voice.nil?
            status = "您未有语音消息.\n"
            status += "感谢您的反馈."
          else
            if @raw_cmd =~ /^1/
                status = "您认为解析: 正确\n"
                status += "执行" + (voice.phantom.update(:yn => "1") ? "成功" : "失败")
                status += "\n" + "感谢您的参与."
            else
                status = "您认为解析: 错误\n"
                status += "执行" + (voice.phantom.update(:yn => "0") ? "成功" : "失败")
                status += "\n" + "感谢您的反馈."
            end
          end
        end
      end
      # help menu
      def help
        "帮助菜单:\n1. 语音说出与时间和金额花费相关的句子\n2. [判断值 空格 意见反馈] 判断值: 1正确/(其他值)错误\n3. ? 查看帮助菜单"
      end
    end # Command

    class Parser
      def initialize(message)
        @message     = message
        @msg_type_hash = {
          "text"     => "文本",
          "news"     => "新闻",
          "music"    => "音乐",
          "image"    => "图片",
          "link"     => "链接",
          "video"    => "视频",
          "voice"    => "音频",
          "location" => "位置",
          "event"    => "事件"
        }
      end

      def handler
        case @message.msg_type
        when "voice" then
          result = %Q{"%s"\n\n} % @message.recognition.force_encoding('UTF-8')
          result += "分解:\n"
          if phantom = @message.phantom
            result += phantom.process
          else
            result += "未创建"
          end
          return result
        when "text"  then 
          Command.exec(@message)
        when "event" then 
          case @message.event.downcase
          when "subscribe"
            @message.weixiner.update(status: @message.event)
            "你好，感谢您参与[小6语记]\n如有疑问请输入: ?"
          when "unsubscribe"
            @message.weixiner.update(status: @message.event)
            "期待您的再次关注"
          when "click"
            case @message.event_key.downcase
            when "personal_report"
              @message.weixiner.personal_report
            else
              "click#%s TODO" % @message.event_key
            end
          when "view"
            # weixin will redirect to menu url
          end
        else 
          "类型为[%s],暂不支持!" % @message.msg_type
        end
      end

      def self.exec(message)
        parser = new(message)
        parser.handler
      end
    end

    module ReplyHelpers
      def reply_robot(message)
        Sinatra::ReplyRobot::Parser.exec(message)
      end
    end

    def self.registered(robot)
      robot.set     :weixin_name,     "NAME"
      robot.set     :weixin_desc,     "DESC"
      robot.helpers  ReplyHelpers
    end
  end # ReplyRobot
  register ReplyRobot
end
