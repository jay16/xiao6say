(function() {
  window.Phantom = {
    search: function(input) {
      var count, date_begin, keyword;
      keyword = $(input).val();
      if (!keyword.trim()) {
        $(".tr-row").removeClass("hidden");
        return $(".search-result").text("");
      } else {
        date_begin = new Date();
        count = 0;
        return $(".phantom").each(function() {
          var date_end, index, keywords, klass, search_duration, text;
          index = $(this).data("index");
          keywords = $(this).data("keywords");
          klass = ".row-" + index;
          if (keywords.indexOf(keyword) >= 0) {
            $(klass).removeClass("hidden");
            count += 1;
          } else {
            $(klass).addClass("hidden");
          }
          date_end = new Date();
          search_duration = (date_end.getTime() - date_begin.getTime()) / 1000;
          text = "找到约" + count + "条结果(用时" + search_duration + "秒)";
          return $(".search-result").text(text);
        });
      }
    }
  };

  $(function() {
    return $('input#search').bind("change keyup input", function() {
      return Phantom.search(this);
    });
  });

}).call(this);
