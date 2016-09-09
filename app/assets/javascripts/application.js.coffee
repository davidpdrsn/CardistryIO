#= require google_analytics
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require jquery-ui/core
#= require jquery-ui/widget
#= require bootstrap-dropdown
#= require chosen
#= require video
#= require jquery.sayt
#= require helpers
#= require ajax_request
#= require_tree .

document.addEventListener "turbolinks:load", ->
  $(".chosen-select").chosen()
  $(".dropdown-toggle").dropdown()

addBehavior "dim-when-clicked", (e) ->
  $(@).addClass("waiting-on-ajax")
