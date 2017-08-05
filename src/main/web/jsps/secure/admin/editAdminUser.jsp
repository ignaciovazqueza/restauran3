<%@ page import="securityfilter.Constants" %>
<%--
  Created by IntelliJ IDEA.
  User: AlumnosFI
  Date: 04/05/2016
  Time: 11:38 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <title><%=Constants.COMMON_TITLE_BASE%>Editar Admin</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
    <link rel="stylesheet" href="/restauran3/css/editAdmin.css">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/zxcvbn/1.0/zxcvbn-async.min.js"></script>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="/restauran3/bootstrap/bootstrap.min.js"></script>

    <link rel="shortcut icon" href="../../../images/Restauran3-logo.png"/>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#password').on('propertychange change keyup paste input', function () {
                var password = $(this).val();
                var passwordScore = zxcvbn(password)['score'];
                var passwordc = $('#passwordc').val();

                var updateMeter = function (width, background, text) {
                    $('#password').css('color', background);
                    $('.strength').text('Seguridad: ' + text).css('color', background);
                    if (passwordc != password) {
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
                if (passwordScore == 1) updateMeter("40%", "#EA4040", "Débil");
                if (passwordScore == 2) updateMeter("60%", "#F58F00", "Mediana");
                if (passwordScore == 3) updateMeter("80%", "#5EFF45", "Buena");
                if (passwordScore == 4) updateMeter("100%", "#1FEC00", "Muy buena");
            });

            $('#passwordc').on('propertychange change keyup paste input', function () {
                var passwordc = $(this).val();
                var password = $('#password').val();
                if (passwordc != password) {
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
                    if (msg.valueOf() == "different") {
                        $('#passworda').val('');
                        alert("La contraseña actual no coincide");
                    } else if (msg.valueOf() == "missing") {
                        alert("Todos los campos deben estar completos");
                    } else if (msg.valueOf() == "ok") {
                        $('#passworda').val('');
                        $('#password').val('');
                        $('#passwordc').val('');
                        $('.strength').text('');
                        alert("La contraseña se guardó con éxito");
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
                    if (msg.valueOf() == "ok") {
                        $('#name').val('').attr("placeholder", name);
                        alert("El nombre de usuario ha sido actualizado con éxito");
                    }
                })
            });

        });
    </script>

</head>

<jsp:include page="adminHome.jsp"/>

<body>
<div class="main">
    <div class="one">
        <div class="edit-user">
            <form id="reg-form" action="../restauran3/editAdmin" method="post">

                <br>
                <div class="center-block panel panel-primary" style="width:50%;text-align: center">
                    <div class="panel-heading">
                        <h3 align="center">Administrador</h3>
                    </div>
                    <div class="panel-body">
                        <h3 align="center"><span class="label label-primary">Usuario</span></h3>
                    </div>

                    <table align="center">
                        <tr>
                            <td>
                                <div class="input-group">
                                    <span class="input-group-addon" id="basic-addon1">Usuario</span>
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="<%=request.getAttribute("username")%>" spellcheck="false"
                                           aria-describedby="basic-addon1">
                                </div>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <div align="center">
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit" class="btn btn-default" name="user" id="user">Actualizar nombre de usuario</button>
                        </div>
                    </div>
                    <div class="panel-body">
                        <h3 align="center"><span class="label label-primary">Contraseña</span></h3>
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <div class="input-group">
                                    <span class="input-group-addon" id="basic-addon2">Contraseña actual</span>
                                    <input type="password" class="form-control" id="passworda" name="passworda"
                                           spellcheck="false"
                                           aria-describedby="basic-addon1">
                                </div>
                            </td>
                    </table>
                    <table align="center">
                        <td>
                            <div class="input-group">
                                <span class="input-group-addon" id="basic-addon3">Nueva contraseña</span>
                                <input type="password" class="form-control" id="password" name="password"
                                       spellcheck="false"
                                       aria-describedby="basic-addon1">
                            </div>
                        </td>
                        <br>
                    </table>
                    <br>
                    <table align="center">
                        <td>
                            <span class="strength"/>
                        </td>
                    </table>
                    <br>
                    <table align="center">
                        <td>
                            <div class="input-group">
                                <span class="input-group-addon" id="basic-addon4">Confirmar nueva contraseña</span>
                                <input type="password" class="form-control" id="passwordc" name="passwordc"
                                       spellcheck="false"
                                       aria-describedby="basic-addon1">
                            </div>
                        </td>
                        </tr>
                    </table>
                    <br>
                    <table align="center">
                        <td>
                            <span class="coincidence"/>
                        </td>
                    </table>
                    <br>
                    <div align="center">
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit" class="btn btn-default" name="add" id="add">Actualizar contraseña</button>
                        </div>
                    </div>
                    <br>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>