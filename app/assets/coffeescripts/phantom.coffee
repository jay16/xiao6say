window.Phantom=
  # search tea with keywords 
  search: (input) ->
    keyword = $(input).val()
    # when keyword is empty then show normal
    if !keyword.trim()
      $(".tr-row").removeClass("hidden")
      $(".search-result").text("")
    else
      date_begin = new Date()
      count = 0
      $(".phantom").each ->
        index    = $(this).data("index")
        keywords = $(this).data("keywords") 
        klass    = ".row-" + index;
        if keywords.indexOf(keyword) >= 0
          $(klass).removeClass("hidden")
          count += 1
        else
          $(klass).addClass("hidden")

        date_end = new Date()
        search_duration = (date_end.getTime() - date_begin.getTime())/1000
        text = "找到约"+count+"条结果(用时" + search_duration+ "秒)"

        $(".search-result").text(text)

$ ->
  # detect the change
  $('input#search').bind "change keyup input", ->
    Phantom.search(this)
