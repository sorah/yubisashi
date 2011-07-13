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
  $("#entry-template-een").val en
  $("#entry-template-eja").val ja
  $("#entry-template-eromaji").val romaji
  $("#entry-template-ecomment").val comment


  foo = $("#entry-template").clone()
  $(foo).find("#entry-template-en")[0].id = ""
  $(foo).find("#entry-template-ja")[0].id = ""
  $(foo).find("#entry-template-romaji")[0].id = ""
  $(foo).find("#entry-template-comment")[0].id = ""
  $(foo).find("#entry-template-een")[0].id = ""
  $(foo).find("#entry-template-eja")[0].id = ""
  $(foo).find("#entry-template-eromaji")[0].id = ""
  $(foo).find("#entry-template-ecomment")[0].id = ""
  $(foo).find("#romaji__")[0].id = "romaji#{id}"
  $(foo)[0].id ="entry#{id}"

  $(foo).find("a.romaji-link").click -> show_romaji(id)
  destroy_bind $(foo).find("a.entry-destroy")[0]
  edit_bind $(foo).find("a.entry-edit")[0]
  $(foo).find(".entry-links a").each (i,v) ->
    v.href = v.href.replace(/__/,json.id)

  $("div.entries").append(foo)

destroy_bind = (v) ->
  $(v).bind 'ajax:success', (data,status,xhr) -> $(v).closest("div.entry").fadeOut(150)
  $(v).bind 'ajax:error', (xhr,status,error) -> alert(error)

edit_bind = (v) ->
  $(v).click ->
    entry = $(v).closest("div.entry")
    if v.editing
      edit_done entry,v
    else
      entry.children("div.entry-editor").show()
      entry.children("div.entry-content").hide()
      $(v).text("Done")
      v.editing = true

edit_done = (entry,v) ->
  return if v.posting
  v.posting = true
  error_box = $(entry).children(".error")
  content = entry.children("div.entry-content")
  editor = entry.children("div.entry-editor")
  id = $(v).closest("div.entry").attr("id").replace(/^entry/,"")

  en = editor.find(".entry-english").val()
  ja = editor.find(".entry-japanese").val()
  romaji = editor.find(".entry-romaji").val()
  comment = editor.find(".entry-comment").val()

  editor.find("input").attr("disabled", true)
  $.ajax(
    type: "POST"
    url: "/entries/#{id}.json"
    dataType: "text"
    data:
      entry:
        english: en
        japanese: ja
        romaji: romaji
        comment: comment
    success: ->
      error_box.hide()
      content.find(".entry-japanese").text ja
      content.find(".entry-english").text en
      content.find(".entry-romaji").text romaji
      content.find(".entry-comment").text comment
      editor.hide()
      content.show()
      $(v).text("Edit")
      v.editing = false
    error: (xhr,txt,err) ->
      if err == "Unprocessable Entity"
        json = JSON.parse(xhr.responseText)
        html = "<b>Validation failed:</b>"
        html += "<ul>"
        for k, v of json
          for msg in v
            html += "<li>#{k} #{msg}</li>"
        error_box.html html+"</ul>"
      else
        error_box.text "XHR Error: #{err}"
      error_box.show()
    complete: (xhr,txt) ->
      editor.find("input").removeAttr("disabled")
      v.posting = false
  )

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
  $("a.entry-destroy").each (i,v) -> destroy_bind(v)
  $("a.entry-edit").each (i,v) -> edit_bind(v)
  $("#entry-new-add").click ->
    add_entry $("#entry-new-en").val(),$("#entry-new-ja").val(),$("#entry-new-romaji").val(),$("#entry-new-comment").val()
    # create_entry_element 100,$("#entry-new-en").val(),$("#entry-new-ja").val(),$("#entry-new-romaji").val(),$("#entry-new-comment").val()
