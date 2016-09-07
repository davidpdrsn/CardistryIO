timeSince = (date) ->
  seconds = Math.floor((new Date - date) / 1000)
  interval = Math.floor(seconds / 31536000)
  if interval > 1
    return interval + ' years'
  interval = Math.floor(seconds / 2592000)
  if interval > 1
    return interval + ' months'
  interval = Math.floor(seconds / 86400)
  if interval > 1
    return interval + ' days'
  interval = Math.floor(seconds / 3600)
  if interval > 1
    return interval + ' hours'
  interval = Math.floor(seconds / 60)
  if interval > 1
    return interval + ' minutes'
  Math.floor(seconds) + ' seconds'

loadTimeAgoInWords = (element) ->
  $element = $(element)
  dateString = $element.attr("datetime")
  timeAgo = timeSince(new Date(dateString)) + " ago"
  $element
    .attr("title", $element.html())
    .html(timeAgo)

# TODO: Update this to work with turbolinks
$ ->
  $("[data-behavior~=dynamic-time-tag]").each -> loadTimeAgoInWords(@)
