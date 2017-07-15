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

    <script src="https://cdnjs.cloudflare.com/ajax/libs/zxcvbn/1.0/zxcvbn-async.min.js"></script>

    <link rel="stylesheet" type="text/css" href="/restauran3/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/restauran3/css/editAdmin.css">

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="/restauran3/bootstrap/bootstrap.min.js"></script>

    <link rel="shortcut icon" href="../../../images/Restauran3-logo.png"/>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#password').on('propertychange change keyup paste input', function () {
                // TODO: only use the first 128 characters to stop this from blocking the browser if a giant password is entered
                var password = $(this).val();
                var passwordScore = zxcvbn(password)['score'];

                var updateMeter = function (width, background, text) {
                    $('.password-background').css({"width": width, "background-color": background});
                    $('.strength').text('Seguridad: ' + text).css('color', background);
                };

                if (passwordScore === 0) {
                    if (password.length === 0) {
                        updateMeter("0%", "#ffa0a0", "Ninguna");
                    } else {
                        updateMeter("20%", "#ffa0a0", "Muy debil");
                    }
                }
                if (passwordScore == 1) updateMeter("40%", "#ffb78c", "Debil");
                if (passwordScore == 2) updateMeter("60%", "#ffec8b", "Mediana");
                if (passwordScore == 3) updateMeter("80%", "#c3ff88", "Segura");
                if (passwordScore == 4) updateMeter("100%", "#ACE872", "Muy segura"); // Color needs changing

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
                                    <input type="text" class="form-control" id="nombre" name="nombre"
                                           placeholder="<%=request.getAttribute("username")%>" spellcheck="false"
                                           aria-describedby="basic-addon1">
                                </div>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <div align="center">
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit" class="btn btn-default" name="user" id="user">Actualizar nombre de
                                usuario
                            </button>
                        </div>
                    </div>
                    <div class="panel-body">
                        <h3 align="center"><span class="label label-primary">Password</span></h3>
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <div class="input-group">
                                    <span class="input-group-addon" id="basic-addon2">Password actual</span>
                                    <input type="password" class="form-control" id="passworda" name="passworda"
                                           spellcheck="false"
                                           aria-describedby="basic-addon1">
                                </div>
                            </td>
                    </table>
                    <table align="center">
                        <td>
                            <div class="input-group">
                                <span class="input-group-addon" id="basic-addon3">Password nueva</span>
                                <input type="password" class="form-control" id="password" name="password"
                                       spellcheck="false"
                                       aria-describedby="basic-addon1">
                                <div class="password-background"/>
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
                                <span class="input-group-addon" id="basic-addon4">Confirmar Password</span>
                                <input type="password" class="form-control" id="passwordc" name="passwordc"
                                       spellcheck="false"
                                       aria-describedby="basic-addon1">
                            </div>
                        </td>
                        </tr>
                    </table>
                    <br>
                    <div align="center">
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit" class="btn btn-default" name="add" id="add">Actualizar password
                            </button>
                            <%--<button onclick="submitPass(<%=request.getAttribute("pass")%>)" class="btn btn-default" name="add" id="add">Actualizar password</button>--%>
                            <%--<input align="center" type="submit" value="Agregar" name="add" class="button" id="add"/>--%>
                        </div>
                        <%--<input type="submit" value="Actualizar" name="add" class="button" id="add"/>--%>
                    </div>
                    <br>
                </div>
            </form>


        </div>
    </div>
</div>

</body>

</html>