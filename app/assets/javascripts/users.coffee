# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on("turbolinks:load" ,->

  $("a.user-delete").on "ajax:success" , (data) -> #异步提交的表单
    if data.detail[0].status == 0
      $(this).parent().parent().hide(300)
)
