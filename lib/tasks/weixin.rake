#encoding:utf-8
desc "tasks operation around weixin"
namespace :weixin do

  def lasttime(info, &block)
     bint = Time.now.to_f
     yield
     eint = Time.now.to_f
     printf("%-10s - %s\n", "[%dms]" % ((eint - bint)*1000).to_i, info)
  end

  task :token => :simple do
    params = []
    { :grant_type => "client_credential",
      :appid      => @options[:weixin_app_id],
      :secret     => @options[:weixin_app_secret]
    }.each_pair do |key, value|
      params.push("%s=%s" % [key, value])
    end
    token_url  = "%s/token?%s" % [@options[:weixin_base_url], params.join("&")]
    hash = JSON.parse(open(token_url).read)
    puts hash
    @options[:weixin_access_token] = hash[:access_token] || hash["access_token"]
    @options[:weixin_expires_in]   = hash[:expires_in]
    @options[:weixin_expires_at]   = Time.now.to_i + hash[:expires_in].to_i
  end
  desc "task operation with weixin user"
  task :user_info => :simple do
    Rake::Task["weixin:token"].invoke
    abort "access_token missing" unless @options[:weixin_access_token]

    Weixiner.all.each do |weixiner|
      next if weixiner.weixiner_info
      params = []
      { :lang         => "zh_CN",
        :openid       => weixiner.uid,
        :access_token => @options[:weixin_access_token]
      }.each_pair do |key, value|
        params.push("%s=%s" % [key, value])
      end
      user_info_url  = "%s/user/info?%s" % [@options[:weixin_base_url], params.join("&")]
      hash = JSON.parse(open(user_info_url).read)
      hash = hash.merge({weixiner_id: weixiner.id})

      puts hash
      weixiner_info = WeixinerInfo.new(hash)
      weixiner_info.save_with_logger
    end
  end
end
