# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

show_romaji = (id) ->
  $("#romaji#{id}").toggle()

$(document).ready ->
  $(".romaji-link").each (i,v) ->
    $(v).click -> show_romaji(v.id.replace(/^romajilink/,""))
