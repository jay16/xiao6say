#encoding: utf-8
require "httparty"
require "json"

class Pgyer
  class << self
    def latest_version_info
      response = HTTParty.post "http://www.pgyer.com/apiv1/app/getAppKeyByShortcut", body:{:shortcut => "xiao6say", :_api_key => "45be6d228e747137bd192c4c47d4f64a"}
      version_info = JSON.parse(response.body)

      latest_version_info = {}
      if response.code == 200 and version_info["code"] == 0
         latest_version_info["appName"]         = version_info["data"]["appName"]
         latest_version_info["appFileSize"]     = version_info["data"]["appFileSize"]
         latest_version_info["appVersion"]      = version_info["data"]["appVersion"]
         latest_version_info["appBuildVersion"] = version_info["data"]["appBuildVersion"]
         latest_version_info["appIdentifier"]   = version_info["data"]["appIdentifier"]
         latest_version_info["appCreated"]      = version_info["data"]["appCreated"]
       else
         puts response.inspect

         latest_version_info["appName"]         = "error"
         latest_version_info["appFileSize"]     = 0
         latest_version_info["appVersion"]      = "error"
         latest_version_info["appBuildVersion"] = "error"
         latest_version_info["appIdentifier"]   = "error"
         latest_version_info["appCreated"]      = "00-00-00 00:00:00"
      end

      return latest_version_info
    end
  end
end