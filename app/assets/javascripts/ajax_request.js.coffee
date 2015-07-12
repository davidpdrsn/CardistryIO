class @AjaxRequest
  constructor: (@url) ->

  run: (f) ->
    @._start()
    $.getJSON @url, =>
      @._done()
      f.apply(window, arguments)

  _start: ->
    console.log "Starting ajax request to #{@url}"

  _done: ->
    console.log "Finished ajax request to #{@url}"
