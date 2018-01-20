<%@ page import="securityfilter.Constants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <title><%=Constants.COMMON_TITLE_BASE%>Editar Admin</title>
    <link rel="stylesheet" href="/restauran3/css/editAdmin.css">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/zxcvbn/1.0/zxcvbn-async.min.js"></script>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>


    <script type="text/javascript">
        $(document).ready(function () {
            var a = $('.link-1')[4];
            a.parentElement.className = 'active';
            $('#password').on('propertychange change keyup paste input', function () {
                var password = $(this).val();
                var passwordScore = zxcvbn(password)['score'];
                var passwordc = $('#passwordc').val();

                var updateMeter = function (width, background, text) {
                    $('#password').css('color', background);
                    $('.strength').text('Seguridad: ' + text).css('color', background);
                    if (passwordc !== password) {
                        $('.coincidence').text('Las contraseñas no coinciden');
                        document.getElementById("add").disabled = true;
                    } else {
                        $('.coincidence').text('');
                        document.getElementById("add").disabled = false;
                    }
                };
                if (passwordScore === 0) {
                    if (password.length === 0) {
                        updateMeter("0%", "#F70000", "Ninguna");
                    } else {
                        updateMeter("20%", "#F70000", "Muy débil");
                    }
                }
                if (passwordScore === 1) updateMeter("40%", "#EA4040", "Débil");
                if (passwordScore === 2) updateMeter("60%", "#F58F00", "Mediana");
                if (passwordScore === 3) updateMeter("80%", "#5EFF45", "Buena");
                if (passwordScore === 4) updateMeter("100%", "#1FEC00", "Muy buena");
            });

            $('#passwordc').on('propertychange change keyup paste input', function () {
                var passwordc = $(this).val();
                var password = $('#password').val();
                if (passwordc !== password) {
                    $('.coincidence').text('Las contraseñas no coinciden');
                    document.getElementById("add").disabled = true;
                } else {
                    $('.coincidence').text('');
                    document.getElementById("add").disabled = false;
                }
            });

            $('#add').click(function (event) {
                event.preventDefault();
                var passworda = $('#passworda').val();
                var password = $('#password').val();
                var passwordc = $('#passwordc').val();
                $.post('../restauran3/editAdmin', {
                    add: "add",
                    passworda: passworda,
                    password: password,
                    passwordc: passwordc
                }, function (responseText) {
                    var msg = '' + responseText.msg + '';
                    if (msg.valueOf() === "different") {
                        $('#passworda').val('');
                        Materialize.toast('La contraseña actual no coincide.', 5000);
                    } else if (msg.valueOf() === "missing") {
                        Materialize.toast('Todos los campos deben estar completos.', 5000);
                    } else if (msg.valueOf() === "ok") {
                        $('#passworda').val('');
                        $('#password').val('');
                        $('#passwordc').val('');
                        $('.strength').text('');
                        Materialize.toast('La contraseña se guardó con éxito.', 5000);
                    }
                })
            });

            $('#user').click(function (event) {
                event.preventDefault();
                var name = $('#name').val();
                $.post('../restauran3/editAdmin', {
                    user: "user",
                    name: name
                }, function (responseText) {
                    var msg = '' + responseText.msg + '';
                    if (msg.valueOf() === "ok") {
                        $('#name').val('').attr("placeholder", name);
                        Materialize.toast('El nombre de usuario ha sido actualizado con éxito.', 5000);
                    }
                })
            });



        });

        function checkAdminName() {
            if ($('#name')[0].value.substring(0,4) === "mesa") {
                $('#user')[0].className += " disabled";
            } else {
                $('#user')[0].className = $('#user')[0].className.substring(0,35);
            }
        }
    </script>

</head>

<jsp:include page="adminHome.jsp"/>

<body>

<div class="row">
    <div class="col s12">
        <div class="center-block panel panel-primary" style="width:85%;text-align: center">
            <form id="reg-form" action="../restauran3/editAdmin" method="post">

                <div class="panel-heading">
                    <div class="card-panel white">
                        <div class="card-content black-text">
                            <span class="card-title" style="font-size: 1.5em;">Administrador</span>
                        </div>
                    </div>
                </div>

                <div class="panel-body">
                    <div class="card-panel white">
                        <div class="card-content black-text">
                            <span class="card-title" style="font-size: 1em;">Usuario</span>
                            <input type="text" class="form-control" id="name" name="name"
                                   placeholder="<%=request.getAttribute("username")%>" spellcheck="false"
                                   onchange="checkAdminName()"
                                   aria-describedby="basic-addon1">
                        </div>
                        <div class="card-action">
                            <div class="btn-group" role="group" aria-label="..." align="center">
                                <button type="submit" class="btn btn-default light-blue darken-3" name="user" id="user">
                                    Actualizar nombre de usuario
                                </button>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="panel-body">
                    <div class="card-panel white">
                        <div class="card-content black-text">

                            <span class="input-group-addon" id="basic-addon2">Contraseña actual</span>
                            <input type="password" class="form-control" id="passworda" name="passworda"
                                   spellcheck="false"
                                   aria-describedby="basic-addon1">

                            <span class="input-group-addon" id="basic-addon3">Nueva contraseña</span>
                            <div class="span">
                                <span class="strength"></span>
                            </div>
                            <input type="password" class="form-control" id="password" name="password"
                                   spellcheck="false"
                                   aria-describedby="basic-addon1">

                            <span class="input-group-addon" id="basic-addon4">Confirmar nueva contraseña</span>
                            <input type="password" class="form-control" id="passwordc" name="passwordc"
                                   spellcheck="false"
                                   aria-describedby="basic-addon1">
                            <div class="span" style="margin-bottom: 15px;">
                                <span class="coincidence center-align"></span>
                            </div>

                        </div>
                        <div class="card-action">
                            <div class="btn-group" role="group" aria-label="..." align="center">
                                <button type="submit" class="btn btn-default light-blue darken-3" name="add" id="add">Actualizar
                                    contraseña
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

            </form>
        </div>
    </div>
</div>

</body>
</html>