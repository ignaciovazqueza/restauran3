<%@ page import="tables.Mesa" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Pedido" %>
<%@ page import="tables.Orden" %>
<%@ page import="servlets.DisplayPedidosServlet" %>
<%@ page import="securityfilter.Constants" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="tables.Menu" %>
<%@ page import="servlets.ClosePedidosServlet" %>
<%--
  Created by IntelliJ IDEA.
  User: Tomas
  Date: 5/10/2016
  Time: 5:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Pedidos</title>
    <jsp:include page="adminHome.jsp"></jsp:include>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
</head>

<body>
<form id="reg-form" action="../restauran3/displaypedidos" method="post">
    <br>
    <div class="center-block panel panel-primary" style="width:50%;text-align: center">
        <div class="panel-heading">
            <h3 align="center">Mesas</h3>
        </div>
        <%  List<Mesa> mesas = (List<Mesa>) request.getAttribute("mesas");
    Orden orden = null;
    List<Pedido> pedidos = new ArrayList<>();
    if(mesas.isEmpty()) {%>

    <div class="panel panel-default">
        <div class="panel-body">
            <h3 align="center"><span class="label label-primary">No hay pedidos.</span></h3>
        </div>
    </div>

        <%}%>


        <%
            for (Mesa mesa : mesas) {
        %>

        <% orden = DisplayPedidosServlet.getOrden(mesa.getMesa());
            if (orden != null) {
                pedidos = DisplayPedidosServlet.getPedidos(orden.getIdorden());
                if (!pedidos.isEmpty()) {
        %>

            <br>

        <div class="panel-body">
            <h3 align="center"><span class="label label-primary"><%=mesa.getMesa().toUpperCase()%></span></h3>
            <table class="table" align="center" width="60%">
                <tr>
                    <td>Pedido</td>
                    <td>Articulo</td>
                    <td>Cantidad</td>
                    <td>Estado</td>
                </tr>
                    <% for (Pedido pedido : pedidos) {
            int id = pedido.getIdPedido();
            Menu articulo = ClosePedidosServlet.getArticulo(pedido.getIdArticulo());
            String estado = articulo.getNombre();
            int cantidad = Integer.parseInt(pedido.getCantidad());
        %>


                <tr>
                    <td><%=id%>
                    </td>
                    <td><%=estado%>
                    </td>
                    <td><%=cantidad%>
                    </td>
                    <td><%=pedido.getEntregado()%>
                    </td>
                    <td><input align="center" type=checkbox name=check id=<%=id%> value=<%=id%>></td>
                </tr>


                    <%}%>
        </div>
        <%
                }
            }
        %>

        </table>


        <%}%>

        <%if (!pedidos.isEmpty()){%>
    <br>
    <div align="center">
        <div class="btn-group" role="group" aria-label="..." align="center">
            <button type="submit" class="btn btn-default" name="entregar">Entregar</button>
        </div>
    </div>
            </div>

    <br>
        <%} else {%>
    <div class="panel panel-default">
        <div class="panel-body">
            <h3 align="center"><span class="label label-primary">No hay pedidos.</span></h3>
        </div>
    </div>
        <%}%>


    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
</body>

</html>
