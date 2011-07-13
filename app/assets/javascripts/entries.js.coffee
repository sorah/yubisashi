# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

show_romaji = (id) ->
  $("#romaji#{id}").toggle()

create_entry_element = (json) ->
  en = json.english
  ja = json.japanese
  romaji = json.romaji
  comment = json.comment
  id = json.id

  $("#entry-template-en").text en
  $("#entry-template-ja").text ja
  $("#entry-template-romaji").text romaji
  $("#entry-template-comment").text comment

  foo = $("#entry-template").clone()
  $(foo).find("#entry-template-en")[0].id = ""
  $(foo).find("#entry-template-ja")[0].id = ""
  $(foo).find("#entry-template-romaji")[0].id = ""
  $(foo).find("#entry-template-comment")[0].id = ""
  $(foo).find("#romaji__")[0].id = "romaji#{id}"
  $(foo)[0].id =""

  $(foo).find("a.romaji-link").click -> show_romaji(id)
  $(foo).find(".entry-links a").each (i,v) ->
    v.href = v.href.replace(/__/,json.id)

  $("div.entries").append(foo)

add_entry = (en,ja,romaji,comment) ->
  $("#entry-new input").attr("disabled", true)
  $.ajax(
    type: "POST"
    url: "/entries.json"
    dataType: "json"
    data:
      entry:
        english: en
        japanese: ja
        romaji: romaji
        comment: comment
    success: (json) ->
      create_entry_element json
      $("#entry-new input[type!=\"button\"]").val ""
      $("#entry-new .error").hide()
    error: (xhr,txt,err) ->
      if err == "Unprocessable Entity"
        json = JSON.parse(xhr.responseText)
        html = "<b>Validation failed:</b>"
        html += "<ul>"
        console.log json
        for k, v of json
          for msg in v
            html += "<li>#{k} #{msg}</li>"
            console.log html
        $("#entry-new .error").html html+"</ul>"
      else
        $("#entry-new .error").text "XHR Error: #{err}"
      $("#entry-new .error").show()
    complete: (xhr,txt) -> $("#entry-new input").removeAttr("disabled")
  )



$(document).ready ->
  $("a.romaji-link").each (i,v) ->
    $(v).click -> show_romaji(v.id.replace(/^romajilink/,""))
  $("#entry-new-add").click ->
    add_entry $("#entry-new-en").val(),$("#entry-new-ja").val(),$("#entry-new-romaji").val(),$("#entry-new-comment").val()
    # create_entry_element 100,$("#entry-new-en").val(),$("#entry-new-ja").val(),$("#entry-new-romaji").val(),$("#entry-new-comment").val()
