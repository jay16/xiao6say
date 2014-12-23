#encoding: utf-8
module StringMethods
  def self.included(base)
    base.class_eval do
      if method_defined?(:recognizer)
        location = self.method(:recoginizer).source_location
        warn "Remove Method - recoginizer defiend in:\n%s\nand reload file in %s" % [location, __FILE__]
        remove_method :recoginizer
      end
    end
  end

  def recoginizer
    unless ENV["APP_ROOT_PATH"]
      puts "\nWARNGING: ENV['APP_ROOT_PATH'] undefined!\n"
    end
    cmd = "%s/lib/utils/recognizer/processPattern %s" % [ENV["APP_ROOT_PATH"], self]
    IO.popen(cmd) do |stdout| 
      stdout.reject(&:empty?) 
    end.unshift($?.exitstatus.zero?)
  end
end
class String
  include StringMethods
end
