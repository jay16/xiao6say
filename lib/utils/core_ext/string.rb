#encoding: utf-8
module StringMethods
  def self.included(base)
    base.class_eval do
      [:process_pattern].each do |method_name|
        next unless method_defined?(method_name)
        location = self.method(method_name).source_location rescue next
        next if location[0] == __FILE__

        warn "Remove Method - #{method_name} defiend in:\n%s\nand reload file in \n%s" % [location, __FILE__]
        remove_method method_name
      end
    end
  end

  def process_pattern
    unless ENV["APP_ROOT_PATH"]
      puts "\nWARNGING: ENV['APP_ROOT_PATH'] undefined!\n"
    end
    cmd = "%s/lib/utils/processPattern/processPattern %s" % [ENV["APP_ROOT_PATH"], self]
    IO.popen(cmd) do |stdout| 
      stdout.reject(&:empty?) 
    end.unshift($?.exitstatus.zero?)
  end
end
class String
  include StringMethods
end
