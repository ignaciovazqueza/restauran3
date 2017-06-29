function submitPass (password){
    var inputPassword = document.getElementById("passworda").value;
    if (inputPassword === password){
        document.getElementById("reg-form").submit();
    } else {
        document.getElementById("passworda").popover('show');
    }
}