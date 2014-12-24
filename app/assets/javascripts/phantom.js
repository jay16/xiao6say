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
    },
    "export": function() {
      var status, url;
      status = [0, 0, 0];
      $("#export input[type=checkbox]").each(function() {
        var index;
        index = $(this).data("index");
        if (App.checkboxState(this)) {
          return status[index] = 1;
        } else {
          return status[index] = 0;
        }
      });
      url = window.location.pathname + "/export?yn=" + status.join("");
      return $("#exportBtn").attr("href", url);
    }
  };

  $(function() {
    $("input#search").bind("change keyup input", function() {
      return Phantom.search(this);
    });
    return $("#export input[type=checkbox]").bind("change", function() {
      return Phantom["export"]();
    });
  });

}).call(this);
