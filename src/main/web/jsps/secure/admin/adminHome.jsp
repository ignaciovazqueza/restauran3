<%@ page import="securityfilter.Constants" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>Admin</title>
    <link rel="stylesheet" href="/restauran3/css/topMenu.css">
</head>
<body>

<nav id="nav-1">
    <a class="link-1" href="${pageContext.request.contextPath}/displaypedidos">Ver Pedidos</a>

    <a class="link-1" href="${pageContext.request.contextPath}/displayassistances">Ver Pedidos de Asistencia</a>

    <a class="link-1" href="${pageContext.request.contextPath}/displaymenu">Ver Menu</a>

    <a class="link-1" href="${pageContext.request.contextPath}/displaytables">Ver Mesas</a>

    <a class="link-1" href="${pageContext.request.contextPath}/editAdmin">Editar Admin</a>

    <a class="link-1" href="${pageContext.request.contextPath}/logout"
       onclick="return confirm('Realmente desea salir del sistema?')">Salir</a>

</nav>

</body>
</html>
