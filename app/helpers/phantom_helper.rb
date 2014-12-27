module PhantomHelper
  def keywords(phantom)
    hash = JSON.parse(phantom.json) rescue {"error" => phantom.json}
    (hash.keys + hash.values).uniq.push(phantom.yn_human).join(",")
  end
end
