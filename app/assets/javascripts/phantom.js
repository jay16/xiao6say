(function() {
  window.Phantom = {
    search: function(input) {
      var count, date_begin, _keys, _keywords;
      _keywords = $(input).val().trim();
      if (!_keywords) {
        $(".tr-row").removeClass("hidden");
        return $(".search-result").text("");
      } else {
        date_begin = new Date();
        count = 0;
        _keys = _keywords.split(/\s+/);
        return $(".phantom").each(function() {
          var date_end, index, keywords, klass, match_status, search_duration, text, _i, _key, _len;
          keywords = $(this).data("keywords");
          index = $(this).data("index");
          klass = ".row-" + index;
          match_status = false;
          for (_i = 0, _len = _keys.length; _i < _len; _i++) {
            _key = _keys[_i];
            if (keywords.indexOf(_key) >= 0) {
              match_status = true;
              break;
            }
          }
          if (match_status) {
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
