<%@ page import="securityfilter.Constants"%>
<%@ page import="tables.Orden" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>User</title>
    <link rel="stylesheet" href="/restauran3/css/topMenu.css">
</head>
<body>

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