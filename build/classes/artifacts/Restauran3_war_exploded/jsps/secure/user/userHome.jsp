<%@ page import="securityfilter.Constants"%>
<%@ page import="tables.Orden" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>User</title>
    <link rel="stylesheet" href="/restauran3/css/topMenu.css">
</head>
<body>

<nav id="nav-1">

    <a class="link-1" href="${pageContext.request.contextPath}/orderitem">Hacer pedido</a>

    <a class="link-1" href="${pageContext.request.contextPath}/closepedidos">Ver pedidos</a>

    <a class="link-1" href="${pageContext.request.contextPath}/askassistance" onclick="alert('Asistencia pedida')">Pedir asistencia</a>

    <a class="link-1" href="${pageContext.request.contextPath}/closetable">Pedir cuenta</a>

    <a class="link-1" href="${pageContext.request.contextPath}/logout"
       onclick="return confirm('Realmente desea salir del sistema?')">Salir</a>
</nav>

</body>
</html>