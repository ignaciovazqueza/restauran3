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
</head>

<jsp:include page="adminHome.jsp"></jsp:include>

<body>
<div class="main">
    <div class="one">
        <div class="edit-user">
            <form id="reg-form" action="../restauran3/editAdmin" method="post">

                <h3 align="center"><span class="label label-primary">Administrador</span></h3>
                <br>
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
                        <td>
                            <div class="input-group">
                                <span class="input-group-addon" id="basic-addon3">Password nueva</span>
                                <input type="password" class="form-control" id="password" name="password"
                                       spellcheck="false"
                                       aria-describedby="basic-addon1">
                            </div>
                        </td>
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
                        <button type="submit" class="btn btn-default" name="add" id="add">Actualizar</button>
                        <%--<input align="center" type="submit" value="Agregar" name="add" class="button" id="add"/>--%>
                    </div>
                    <%--<input type="submit" value="Actualizar" name="add" class="button" id="add"/>--%>
                </div>
            </form>

        </div>
    </div>
</div>

<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="js/bootstrap.min.js"></script>
</body>

</html>