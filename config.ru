#encoding: utf-8
@app_routes_map = {
  "/"                  => "HomeController",
  "/weixin"            => "WeixinController",
  "/user"              => "UserController",
  "/api/device"        => "API::DeviceController",
  "/api/weixiner"      => "API::WeixinerController",
  "/cpanel"            => "Cpanel::HomeController",
  "/cpanel/weixiners"  => "Cpanel::WeixinersController",
  "/cpanel/messages"   => "Cpanel::MessagesController",
  "/cpanel/phantoms"   => "Cpanel::PhantomsController",
  "/cpanel/change_log" => "Cpanel::ChangeLogController",
  "/cpanel/devices"    => "Cpanel::DevicesController"
}

require "./config/boot.rb"

@app_routes_map.each_pair do |path, mod|
  clazz = mod.split("::").inject(Object) {|o,c| o.const_get c}
  map(path) { run clazz }

  #clazz.routes.each do |verb, list|
  #  puts "verb: %s" % verb
  #  puts list.class
  #  list.each do |data|
  #    puts data.join("\t")
  #  end
  #end
end
