<%@ page import="securityfilter.Constants" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>Admin</title>
    <link rel="stylesheet" href="/restauran3/css/topMenu.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="/restauran3/materialize/css/materialize.min.css">
    <link rel="stylesheet" href="/restauran3/css/jquery-ui.css">
    <link rel="shortcut icon" href="/restauran3/images/Restauran3-logo.png"/>

    <script src="/restauran3/js/util/jquery-3.2.1.js"></script>
    <script src="/restauran3/js/util/jquery-ui.js"></script>
    <script src="/restauran3/materialize/js/materialize.min.js"></script>
</head>

<body>
<script>
    $(document).ready(function () {
        $('.button-collapse').sideNav({
                menuWidth: 240,
                edge: 'left',
                closeOnClick: true
            }
        );
    });
</script>

<div class="col s12">
    <nav>
        <div class="nav-wrapper light-blue darken-3">
            <a href="#!" data-activates="slide-out" class="button-collapse"><i class="material-icons">menu</i></a>
            <ul class="left hide-on-med-and-down">
                <li><img class="circle" alt="" src="/restauran3/images/Restauran3-logo.png"
                         style="width: 50px; height: 50px; margin-top: 8px; margin-left: 10px"></li>
            </ul>
            <ul class="right hide-on-med-and-down">
                <li><a class="link-1" href="${pageContext.request.contextPath}/displaypedidos" name="pedidos"
                       id="pedidos">Ver Pedidos</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/displayassistances" name="asistencia"
                       id="asistencia">Ver Pedidos de Asistencia</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/displaymenu">Ver Menu</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/displaytables">Ver Mesas</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/editAdmin">Editar Admin</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/logout"
                       onclick="return confirm('Realmente desea salir del sistema?')">Salir</a></li>
            </ul>
            <ul id="slide-out" class="side-nav">
                <li>
                    <div class="user-view">
                        <div class="background nav-wrapper light-blue darken-3" style="height: 130px"></div>
                        <div>
                            <img class="circle" alt="" src="/restauran3/images/Restauran3-logo.png">
                        </div>
                        <span class="white-text name" style="font-size: 2em; display: inline-block">Restauran3</span>
                    </div>
                </li>
                <li style="margin-top: 5px"><a class="link-1" href="${pageContext.request.contextPath}/displaypedidos">Ver Pedidos</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/displayassistances">Ver Pedidos de Asistencia</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/displaymenu">Ver Menu</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/displaytables">Ver Mesas</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/editAdmin">Editar Admin</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/logout"
                       onclick="return confirm('Realmente desea salir del sistema?')">Salir</a></li>
            </ul>
        </div>
    </nav>
</div>

</body>
</html>