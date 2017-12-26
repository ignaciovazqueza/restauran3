<%@ page import="securityfilter.Constants"%>
<%@ page import="tables.Orden" %>

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

<input type="hidden" name="user" id="user" >

<nav id="nav-1">

    <a class="link-1" href="${pageContext.request.contextPath}/orderitem">Hacer pedido</a>

    <a class="link-1" href="${pageContext.request.contextPath}/closepedidos">Ver pedidos</a>

    <a class="link-1" href="${pageContext.request.contextPath}/askassistance">Pedir asistencia</a>

    <a class="link-1" href="${pageContext.request.contextPath}/closetable">Pedir cuenta</a>

    <a class="link-1" href="jsps/outroPage.jsp" onclick="return confirm('Realmente desea salir del sistema?')">Salir</a>
</nav>




</body>
</html>