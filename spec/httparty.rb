require "httparty"

response = HTTParty.post "http://www.pgyer.com/apiv1/app/getAppKeyByShortcut", body:{:shortcut => "xiao6say", :_api_key => "45be6d228e747137bd192c4c47d4f64a"}
puts response.body.class