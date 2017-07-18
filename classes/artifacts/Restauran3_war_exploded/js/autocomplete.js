$(function() {
    var autoCategorias = JSON.parse(document.getElementById("jsonArray"));
    $("#categoria").autocomplete({
        source: autoCategorias
    });
});
