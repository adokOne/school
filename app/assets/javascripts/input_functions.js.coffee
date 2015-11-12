removeextra = ->
  initVal = $(this).val()
  outputVal = initVal.replace(/[^а-яА-Яa-zA-Z\s-]/g, '')
  if initVal != outputVal
    $(this).val outputVal
  return

remove_without_coma = ->
  initVal = $(this).val()
  outputVal = initVal.replace(/[^а-яА-Яa-zA-Z\s-,]/g, '')
  if initVal != outputVal
    $(this).val outputVal
  return

removecyrylic = ->
  initVal = $(this).val()
  outputVal = initVal.replace(/[а-яА-Я]/g, '')
  if initVal != outputVal
    $(this).val outputVal
  return



$(document).ready ->
  $('.alpha').keyup(removeextra).blur removeextra
  $('.alpha_without_coma').keyup(remove_without_coma).blur remove_without_coma
  $('.without_cyrylic').keyup(removecyrylic).blur removecyrylic
