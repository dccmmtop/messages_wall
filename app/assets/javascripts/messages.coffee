# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on("turbolinks:load" ,->
  $("a.comment-delete").on "ajax:success" , (data) -> #异步提交的表单
    if data.detail[0].status == 0
      $(this).parent().parent().hide(300)
      comments_count = $(".comment-main > div.card-header > span").text() - 0
      $(".comment-main > div.card-header > span").text(comments_count - 1)


  $("a.message-delete").on "ajax:success" , (data) -> #异步提交的表单
    if data.detail[0].status == 0
      $(this).parent().parent().hide(300)
)
