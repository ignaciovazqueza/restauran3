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

    <script type="text/javascript">

        var webSocket;
        // var messages = document.getElementById("messages");

        function openSocket() {
            // Ensures only one connection is open at a time
            if (webSocket !== undefined && webSocket.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            // Create a new instance of the websocket
            webSocket = new WebSocket("ws://192.168.0.104:8080/restauran3/pedido");

            /**
             * Binds functions to the listeners for the websocket.
             */
            webSocket.onopen = function (event) {
                // For reasons I can't determine, onopen gets called twice
                // and the first time event.data is undefined.
                // Leave a comment if you know the answer.
                if (event.data === undefined)
                    return;

                writeResponse(event.data);
            };

            webSocket.onmessage = function (event) {
                if (event.data==("pedido")){
                    writePedidoResponse(event.data);
                }

            };

            webSocket.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        /**
         * Sends the value of the text input to the server
         */

        function closeSocket() {
            webSocket.close();
        }

        function writeResponse(text) {
            //  messages.innerHTML += "<br/>" + text;
            if (text=="pedido"){
                console.log(text);
                location.reload();
            }
            //    $('#tabla tr:last').after('<tr><td><input type=text value="' + responseText.nombre + '"id="' + responseText.nombre + '"></td><td><input type=text value="' + responseText.precio + '"id="' + responseText.precio + '"></td><td><input type=radio name="radio"  value=' + responseText.id + ' ></td></tr>');
        }
        function writePedidoResponse(text){
            location.reload()
        }

        function window_onload() {
            openSocket();
        }

    </script>

    <script type="text/javascript">

        var webSocketO;
        // var messages = document.getElementById("messages");

        function openSocketO() {
            // Ensures only one connection is open at a time
            if (webSocketO !== undefined && webSocketO.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            // Create a new instance of the websocket
            webSocketO = new WebSocket("ws://192.168.0.104:8080/restauran3/orden");

            /**
             * Binds functions to the listeners for the websocket.
             */
            webSocketO.onopen = function (event) {
                // For reasons I can't determine, onopen gets called twice
                // and the first time event.data is undefined.
                // Leave a comment if you know the answer.
                if (event.data === undefined)
                    return;

                writeResponse(event.data);
            };

            webSocketO.onmessage = function (event) {
                if (event.data==("pedido")){
                    writePedidoResponse(event.data);
                }

            };

            webSocketO.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        /**
         * Sends the value of the text input to the server
         */

        function closeSocketO() {
            webSocketO.close();
        }

        function writeResponse(text) {
            //  messages.innerHTML += "<br/>" + text;
            if (text=="pedido"){
                console.log(text);
                location.reload();
            }
            //    $('#tabla tr:last').after('<tr><td><input type=text value="' + responseText.nombre + '"id="' + responseText.nombre + '"></td><td><input type=text value="' + responseText.precio + '"id="' + responseText.precio + '"></td><td><input type=radio name="radio"  value=' + responseText.id + ' ></td></tr>');
        }
        function writePedidoResponse(text){
            location.reload()
        }
        function changeWS(){
            //closeSocket();
            openSocketO();
            sendOrden();
        }

        function sendOrden(){
            var text = "orden";
            webSocketO.send(text);

        }

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
                        <button type="submit" class="btn btn-default" name="cerrar" id="cerrar" onclick="changeWS()">Cerrar Pedido</button>
                    </div>
                </td>
                <td>
                    <div class="btn-group" role="group" aria-label="..." align="center">
                        <button type="submit" class="btn btn-default" name="eliminar" id="eliminar" onclick="changeWS()">Eliminar</button>
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