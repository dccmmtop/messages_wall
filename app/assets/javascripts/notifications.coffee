# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on("turbolinks:load" ,->
  $(".span-delete").click ->
    r = confirm("确定删除此条公告吗？")
    if r
      $.ajax({
        type: "DELETE"
        url: 'notifications/' + $(this).data("id")
      })
    return false
)
