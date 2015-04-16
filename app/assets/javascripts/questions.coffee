# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('body').on 'click', 'a.edit-question-link', (e) ->
   e.preventDefault()
   $(this).hide()
   $('form.edit_question').show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
