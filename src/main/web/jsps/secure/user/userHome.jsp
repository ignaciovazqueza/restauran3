<%@ page import="securityfilter.Constants" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>User</title>
    <link rel="stylesheet" href="/restauran3/css/topMenu.css">
    <link rel="stylesheet" href="/restauran3/css/jquery-ui.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="/restauran3/materialize/css/materialize.min.css">

    <script src="/restauran3/js/util/jquery-3.2.1.js"></script>
    <script src="/restauran3/js/util/jquery-ui.js"></script>
    <script src="/restauran3/materialize/js/materialize.min.js"></script>
</head>

<body>
<script>
    $( document ).ready(function(){
        $('.button-collapse').sideNav({
                    menuWidth: 300, // Default is 240
                    edge: 'left', // Choose the horizontal origin
                    closeOnClick: true // Closes side-nav on <a> clicks, useful for Angular/Meteor
                }
        );
    });
</script>

<div class="col s12">
    <nav>
        <div class="nav-wrapper">
            <a href="#!" data-activates="slide-out" class="button-collapse"><i class="material-icons">menu</i></a>
            <ul class="left hide-on-med-and-down">
                <li><img class="circle" alt="" src="/restauran3/images/Restauran3-logo.png" style="width: 50px; height: 50px; margin-top: 8px; margin-left: 10px"></li>
            </ul>
            <ul class="right hide-on-med-and-down">
                <li><a class="link-1" href="${pageContext.request.contextPath}/orderitem">Hacer pedido</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/closepedidos">Ver pedidos</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/askassistance">Pedir asistencia</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/closetable">Pedir cuenta</a></li>
                <li><a class="link-1" href="/restauran3/jsps/outroPage.jsp" onclick="return confirm('Realmente desea salir del sistema?')">Salir</a></li>
            </ul>
            <ul id="slide-out" class="side-nav">
                <li>
                    <div class="user-view">
                        <div class="background nav-wrapper"></div>
                        <div>
                            <img class="circle" alt="" src="/restauran3/images/Restauran3-logo.png">
                        </div>
                        <span class="white-text name" style="font-size: 2em; display: inline-block">Restauran3</span>
                    </div>
                </li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/orderitem">Hacer pedido</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/closepedidos">Ver pedidos</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/askassistance">Pedir asistencia</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/closetable">Pedir cuenta</a></li>
                <li><a class="link-1" href="/restauran3/jsps/outroPage.jsp" onclick="return confirm('Realmente desea salir del sistema?')">Salir</a></li>
            </ul>
        </div>
    </nav>
</div>

</body>
</html>