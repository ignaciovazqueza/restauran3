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
    <script src="/restauran3/js/util/jquery-3.2.1.js"></script>

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
                if (event.data=="orden"){
                    writeOrdenResponse(event.data);
                }

            };

            webSocketO.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        /**
         * Sends the value of the text input to the server
         */
        function sendOrden() {
            //  var text = document.getElementById("messageinput").value;
//            var text = "pedido";
//            webSocket.send(text);
      //      var text = "orden";
  //          webSocket.send();
        }

        function closeSocket() {
            webSocketO.close();
        }

        function writeResponse(text) {
            //  messages.innerHTML += "<br/>" + text;
                console.log(text);
                location.reload();
            //    $('#tabla tr:last').after('<tr><td><input type=text value="' + responseText.nombre + '"id="' + responseText.nombre + '"></td><td><input type=text value="' + responseText.precio + '"id="' + responseText.precio + '"></td><td><input type=radio name="radio"  value=' + responseText.id + ' ></td></tr>');
        }
        function writeOrdenResponse(text){
            location.reload();
        }

        function window_onload() {
            openSocketO();
        }


    </script>
</head>

<body onload="window_onload();">

<script>

    $(document).ready(function () {
        $("button").click(function (event){
            var name = $(this).attr('id')
            $.post('../restauran3/displaypedidos', {
                id: name
            });
        });
    });
</script>


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
                    <%--<td><input align="center" type=checkbox name=check id=<%=id%> value=<%=id%>></td>--%>
                    <td><div class="btn-group" role="group" aria-label="..." align="center">
                        <button type="submit" class="btn btn-default" id=<%=id%> name="entregar" >Entregar</button>
                    </div></td>
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
    <%--<div align="center">--%>
        <%--<div class="btn-group" role="group" aria-label="..." align="center">--%>
            <%--<button type="submit" class="btn btn-default" name="entregar">Entregar</button>--%>
        <%--</div>--%>
    <%--</div>--%>
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
