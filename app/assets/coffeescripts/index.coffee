window.Index = 
  resizeWindow: => 
    w = window
    d = document
    e = d.documentElement
    g = d.getElementsByTagName("body")[0]
    x = w.innerWidth or e.clientWidth or g.clientWidth
    y = w.innerHeight or e.clientHeight #|| g.clientHeight;
    $(".bs-docs-masthead").css
      "min-height": y + "px"

    heightMinusFooter = y - 24;
    $(".bs-docs-featurette").css
      "min-height": heightMinusFooter + "px"
      
    $("footer").css
      "height": "24px"

$ ->
  Index.resizeWindow()

  currentDate = new Date();
  copyInfo = "&copy; " + currentDate.getFullYear() + " " + window.location.host;
  $("footer").html(copyInfo);