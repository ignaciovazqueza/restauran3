<%@ page import="securityfilter.Constants" %>
<%@ page import="tables.Pedido" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Menu" %>
<%@ page import="servlets.ClosePedidosServlet" %><%--
  Created by IntelliJ IDEA.
  User: AlumnosFI
  Date: 18/05/2016
  Time: 10:53 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Cuenta</title>
</head>

<jsp:include page="userHome.jsp"></jsp:include>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<body>
<form id="reg-form" action="../restauran3/closetable" method="post">
    <%  List<Pedido> entregados = (List<Pedido>) request.getAttribute("entregados");
        List<Pedido> alaespera = (List<Pedido>) request.getAttribute("alaespera");
        int sumatotal = 0;
        if (!entregados.isEmpty() || !alaespera.isEmpty()){
    %>
    <br>
    <br>
    <div class="center-block panel panel-primary" style="width:50%;text-align: center">
        <div class="panel-heading">
            <h3 align="center">Cuenta</h3>
        </div>

        <table align ="center" class="table" width="60%">
            <tr>
                <td>Articulo</td>
                <td>Cantidad</td>
                <td>Precio</td>
                <td>Total Parcial</td>
            </tr>

            <% for (Pedido pedido : entregados){
                Menu articulo = ClosePedidosServlet.getArticulo(pedido.getIdArticulo());
                String estado =articulo.getNombre();
                int cantidad = Integer.parseInt(pedido.getCantidad());
                int precio = articulo.getPrecio();
                int total= cantidad*precio;
                sumatotal += total;
            %>

            <tr>
                <td><%=estado%></td>
                <td><%=cantidad%></td>
                <td>$<%=precio%></td>
                <td>$<%=total%></td>
            </tr>

            <%}%>

            <% for (Pedido pedido : alaespera){
                Menu articulo = ClosePedidosServlet.getArticulo(pedido.getIdArticulo());
                String estado =articulo.getNombre();
                int cantidad = Integer.parseInt(pedido.getCantidad());
                int precio = articulo.getPrecio();
                int total= cantidad*precio;
                sumatotal += total;
            %>

            <tr>
                <td><%=estado%></td>
                <td><%=cantidad%></td>
                <td>$<%=precio%></td>
                <td>$<%=total%></td>
            </tr>

            <%}%>

        </table>

        <br>
        <table align ="center" class="table" width="60%">
            <tr>
                <td>Total:</td>
                <td>$<%=sumatotal%></td>
            </tr>
        </table>

        <br>
        <div align="center">
            <div class="btn-group" role="group" aria-label="..." align="center">
                <button type="submit" class="btn btn-default" id="close-table" name="entregar"
                        onclick="return confirm('¿Realmente desea pedir la cuenta? Si clickea en Aceptar, se procederá en quitarlo del sistema.')">Pedir Cuenta</button>
            </div>
        </div>
        <br>
    </div>
</form>

<%} else {%>
<div class="panel panel-default">
    <div class="panel-body">
        <h3 align="center"><span class="label label-primary">No hay pedidos.</span></h3>
    </div>
</div>
<%}%>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>

</body>
</html>
