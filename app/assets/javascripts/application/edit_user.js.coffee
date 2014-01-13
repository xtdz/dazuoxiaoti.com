$.UserEditPage = {
  toggleEdit : (div) ->
    $("div.edit.visible").removeClass("visibile").hide();
    $("div.edit." + div).addClass("visible").show();
}
