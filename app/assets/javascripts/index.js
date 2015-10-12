(function() {
  window.Index = {
    resizeWindow: (function(_this) {
      return function() {
        var d, e, g, heightMinusFooter, w, x, y;
        w = window;
        d = document;
        e = d.documentElement;
        g = d.getElementsByTagName("body")[0];
        x = w.innerWidth || e.clientWidth || g.clientWidth;
        y = w.innerHeight || e.clientHeight;
        $(".bs-docs-masthead").css({
          "min-height": y + "px"
        });
        heightMinusFooter = y - 24;
        $(".bs-docs-featurette").css({
          "min-height": heightMinusFooter + "px"
        });
        return $("footer").css({
          "height": "24px"
        });
      };
    })(this)
  };

  $(function() {
    var copyInfo, currentDate;
    Index.resizeWindow();
    currentDate = new Date();
    copyInfo = "&copy; " + currentDate.getFullYear() + " " + window.location.host;
    return $("footer").html(copyInfo);
  });

}).call(this);
