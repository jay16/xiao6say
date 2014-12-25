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

  # export weixin example sentences 
  export: ->
    status = [0,0,0]
    $("#export input[type=checkbox]").each ->
      index = $(this).data("index")
      if App.checkboxState(this)
        status[index] = 1
      else
        status[index] = 0
    url = window.location.pathname + "/export?yn=" + status.join("")
    $("#exportBtn").attr("href", url)

  # re process text str with phantom's code
  process: (id) ->
    date_begin = new Date()
    $("#processModal").modal("show")
    $("#phantom_id").attr("value", id)
    $.ajax(
      type: "post"
      url: "/cpanel/phantoms/process"
      data: { "id": id }
      dataType: "json"
      success: (data) ->
        string = JSON.stringify(data)
        $(".process-result").html(string)
        $("#phantom_json").attr("value", string)
        $("#processBtn").removeAttr("disabled")
      error: ->
        $(".process-result").html("ajax错误")
        $("#processBtn").attr("disabled", "disabled")
    );
    
    date_end = new Date()
    search_duration = (date_end.getTime() - date_begin.getTime())/1000
    $(".process-duration").html("用时" + search_duration+ "秒")

$ ->
  # detect the change
  $("input#search").bind "change keyup input", ->
    Phantom.search(this)

  $("#export input[type=checkbox]").bind "change", ->
    Phantom.export()
