# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $("#server_list").dataTable(
    { paging: false }
  )

  $("#advisories_list").dataTable(
    { paging: false }
  )

  $("#ossec_list").dataTable(
    { paging: false }
  )

  $("#ossec_show").dataTable(
    { paging: false }
  )
