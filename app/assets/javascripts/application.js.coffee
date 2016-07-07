#= require jquery
#= require jquery_ujs
#= require jquery-ui/core
#= require jquery-ui/widget
#= require bootstrap-dropdown
#= require chosen
#= require jquery.sayt
#= require helpers
#= require ajax_request
#= require_tree .

$ ->
  $(".chosen-select").chosen()
  $('.dropdown-toggle').dropdown()

  addBehavior "show-comment-form", (e) ->
    e.preventDefault()
    console.log $(".add_comment_form")
    $(".add_comment_form").toggleClass "hide"
