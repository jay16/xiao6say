#encoding: utf-8
require "net/ssh"
require "net/scp"
desc "remote deploy application."
namespace :remote do
  def encode(data)
    data.to_s.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
  end

  def execute!(ssh, command)
    puts "\t`%s`" % command
    ssh.exec!(command) do  |ch, stream, data|
      begin
        puts "\t\t%s: %s" % [stream, data]
      rescue
        puts "\t\t%s: %s" % [stream, encode(data)]
      end
    end
  end

  desc "scp local config files to remote server."
  task :deploy => :environment do
    remote_root_path = Settings.server.app_root_path
    local_config_path  = "%s/config" % ENV["APP_ROOT_PATH"]
    remote_config_path = "%s/config" % remote_root_path
    yamls = Dir.entries(local_config_path).find_all { |file| File.extname(file) == ".yaml" }
    Net::SSH.start(Settings.server.host, Settings.server.user, :password => Settings.server.password) do |ssh|
      _dirname  = File.dirname(remote_root_path)
      _basename = File.basename(remote_root_path)
      _git_url  = "git@github.com:jay16/xiao6say.git"
      command = "cd %s && test -d %s || git clone %s" % [_dirname, _basename, _git_url]
      execute!(ssh, command)

      command = "cd %s && git reset --hard HEAD && git pull origin master" % remote_root_path
      execute!(ssh, command)

      # check whether remote server exist yaml file
      yamls.each do |yaml|
        command = "test -f %s/%s && echo '%s - exist' || echo '%s - not found.'" % [remote_config_path, yaml, yaml, yaml]
        execute!(ssh, command)
        ssh.scp.upload!("%s/%s" % [local_config_path, yaml], remote_config_path) do |ch, name, sent, total| 
          print "\rupload #{name}: #{(sent.to_f * 100 / total.to_f).to_i}%"
        end
        puts "\n"
      end

      puts "bundle --local"
      command = "cd %s && bundle --local" % remote_root_path
      execute!(ssh, command)

      puts "stop unicorn"
      command = "cd %s && /bin/sh unicorn.sh stop" % remote_root_path
      execute!(ssh, command)

     # puts "rake get weixiner info"
     # command = "cd %s && RACK_ENV=production bundle exec rake weixin:user_info" % remote_root_path
     # execute!(ssh, command)

      puts "start unicorn"
      command = "cd %s && /bin/sh unicorn.sh start" % remote_root_path
      execute!(ssh, command)

      puts "download db files"
      database_name = "%s_%s" % [ENV["APP_NAME"], ENV["RACK_ENV"]]
      remote_db_path = "%s/db/%s.db" % [remote_root_path, database_name]
      local_db_path  = "%s/db/%s.db" % [ENV["APP_ROOT_PATH"], database_name]
      File.delete(local_db_path) if File.exist?(local_db_path)
      ssh.scp.download!(remote_db_path, local_db_path)
    end
  end
end
