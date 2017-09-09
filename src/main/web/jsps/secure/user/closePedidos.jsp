<%@ page import="securityfilter.Constants" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Pedido" %>
<%@ page import="servlets.ClosePedidosServlet" %>
<%@ page import="tables.Menu" %><%--
  Created by IntelliJ IDEA.
  User: AlumnosFI
  Date: 11/05/2016
  Time: 11:31 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Pedidos</title>
    <% String username = request.getUserPrincipal().getName();%>
    <script src="/restauran3/js/util/jquery-3.2.1.js"></script>
    <input type="hidden" value="<%=username%>" id="user">

    <script type="text/javascript">

        var webSocketP;
        var ip = "10.10.10.6";

        function openSocketP() {

            if (webSocketP !== undefined && webSocketP.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }

            webSocketP = new WebSocket("ws://" + ip + ":8080/restauran3/pedido");

            webSocketP.onopen = function (event) {
                if (event.data === undefined)
                    return;
                writeResponse(event.data);
            };

            webSocketP.onmessage = function (event) {
                if (event.data=="pedido"){
                    writePedidoResponse(event.data);
                }
            };

            webSocketP.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        function sendPedido() {
            var user = document.getElementById('user').value;
            var text = "pedido " + user;
            webSocketP.send(text);
        }

        function closeSocketP() {
            webSocketP.close();
        }

        function writeResponse(text) {
            console.log(text);
        }

        function writePedidoResponse(text){
            location.reload();
        }

        function window_onload() {
            openSocketP();
        }

        //$(document).ready(function () {
          //  $("button[name='eliminar']").click(function (event) {
            //    location.reload();
            //});
        //});

    </script>

</head>

<jsp:include page="userHome.jsp"></jsp:include>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<body onload="window_onload();">

<form id="reg-form" action="../restauran3/closepedidos" method="post">
    <% List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
        if (!pedidos.isEmpty()) {
    %>
    <br>
    <br>
    <div class="center-block panel panel-primary" style="width:50%;text-align: center">
        <div class="panel-heading">
            <h3 align="center">Pedidos Actuales</h3>
        </div>
        <table align="center" class="table" width="60%">
            <tr>
                <td>Articulo</td>
                <td>Cantidad</td>
                <td>Precio</td>
                <td>Total Parcial</td>
            </tr>
            <% for (Pedido pedido : pedidos) {
                int id = pedido.getIdPedido();
                Menu articulo = ClosePedidosServlet.getArticulo(pedido.getIdArticulo());
                String estado = articulo.getNombre();
                int cantidad = Integer.parseInt(pedido.getCantidad());
                int precio = articulo.getPrecio();
                int total = cantidad * precio;
            %>

            <tr>
                <td><%=estado%>
                </td>
                <td><%=cantidad%>
                </td>
                <td>$<%=precio%>
                </td>
                <td>$<%=total%>
                </td>
                <td><input align="center" type=checkbox name=check id=<%=id%> value=<%=id%>></td>
            </tr>

            <%}%>


        </table>

        <br>
        <div align="center">
            <table>
                <td>
                    <div class="btn-group" role="group" aria-label="..." align="center">
                        <button type="submit" class="btn btn-default" name="cerrar" id="cerrar" onclick="sendPedido()">Cerrar Pedido</button>
                    </div>
                </td>
                <td>
                    <div class="btn-group" role="group" aria-label="..." align="center">
                        <button type="submit" class="btn btn-default" name="eliminar" id="eliminar">Eliminar</button>
                    </div>
                </td>
            </table>
        </div>
        </div>
</form>
<br>

<%}%>

<% List<Pedido> alaespera = (List<Pedido>) request.getAttribute("alaespera");
    if (!alaespera.isEmpty()) {
%>
<br>

</div>
<div class="center-block panel panel-primary" style="width:50%;text-align: center">
    <div class="panel-heading">
        <h3 align="center">Pedidos a la espera de ser entregados</h3>
    </div>

    <table align="center" class="table" width="60%">
        <tr>
            <td>Articulo</td>
            <td>Cantidad</td>
            <td>Precio</td>
            <td>Total Parcial</td>
        </tr>
        <% for (Pedido pedido : alaespera) {
            Menu articulo = ClosePedidosServlet.getArticulo(pedido.getIdArticulo());
            String estado = articulo.getNombre();
            int cantidad = Integer.parseInt(pedido.getCantidad());
            int precio = articulo.getPrecio();
            int total = cantidad * precio;
        %>

        <tr>
            <td><%=estado%>
            </td>
            <td><%=cantidad%>
            </td>
            <td>$<%=precio%>
            </td>
            <td>$<%=total%>
            </td>
        </tr>

        <%}%>


    </table>
    <%}%>
</div>
<% List<Pedido> entregados = (List<Pedido>) request.getAttribute("entregados");
    if (!entregados.isEmpty()) {
%>
<br>
<div class="center-block panel panel-primary" style="width:50%;text-align: center">
    <div class="panel-heading">
        <h3 align="center">Pedidos ya entregados</h3>
    </div>

    <table align="center" class="table" width="60%">
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
                    %>

        <tr>
            <td><%=estado%>
            </td>
            <td><%=cantidad%>
            </td>
            <td>$<%=precio%>
            </td>
            <td>$<%=total%>
            </td>
        </tr>

            <%}%>

</div>
</table>
<%}%>

<% if ((pedidos.isEmpty() && alaespera.isEmpty()) && entregados.isEmpty()) {%>
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