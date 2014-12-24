module PhantomHelper
  def keywords(str)
    hash = JSON.parse(str)
    (hash.keys + hash.values).uniq.join(",")
  end
end
