window.Phantom=
  # search tea with keywords 
  search: (input) ->
    _keywords = $(input).val().trim()

    # when keyword is empty then show normal
    if !_keywords
      $(".tr-row").removeClass("hidden")
      $(".search-result").text("")
    else
      date_begin = new Date()
      count = 0
      _keys = _keywords.split(/\s+/)
      $(".phantom").each ->
        keywords = $(this).data("keywords")
        index    = $(this).data("index")
        klass    = ".row-" + index;

        match_status = false
        for _key in _keys
           if keywords.indexOf(_key) >= 0
             match_status = true
             break

        if match_status
          $(klass).removeClass("hidden")
          count += 1
        else
          $(klass).addClass("hidden")

        date_end = new Date()
        search_duration = (date_end.getTime() - date_begin.getTime())/1000
        text = "找到约"+count+"条结果(用时" + search_duration+ "秒)"

        $(".search-result").text(text)

  export: ->
    status = [0,0,0]
    $("#export input[type=checkbox]").each ->
      index = $(this).data("index")
      if App.checkboxState(this)
        status[index] = 1
      else
        status[index] = 0
    # url = window.location.protocol + "//" + window.location.host + 
    # window.open(url,'newwindow','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    url = window.location.pathname + "/export?yn=" + status.join("")
    $("#exportBtn").attr("href", url)

$ ->
  # detect the change
  $("input#search").bind "change keyup input", ->
    Phantom.search(this)

  $("#export input[type=checkbox]").bind "change", ->
    Phantom.export()
