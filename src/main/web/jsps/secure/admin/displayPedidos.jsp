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

        var webSocketPP;
        var ip = "192.168.1.110";

        function openSocketPP() {
            if (webSocketPP !== undefined && webSocketPP.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            webSocketPP = new WebSocket("ws://" + ip + ":8080/restauran3/pedido");

            webSocketPP.onopen = function (event) {
                if (event.data === undefined)
                    return;
                writeResponse(event.data);
            };

            webSocketPP.onmessage = function (event) {
                var parts = event.data.split(" ");
                var action = parts[0];
                var user = parts[1];
                if (action == "pedido") {
                    setTimeout(writeAsistenciaResponsePP(event.data),1000);
                }
            };

            webSocketPP.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        function send() {
        }

        function closeSocketPP() {
            webSocketPP.close();
        }

        function writeAsistenciaResponsePP(text) {
            location.reload();
//            var parts = text.split(" ");
//            var action = parts[0];
//                var user = parts[1];
//                var table = document.getElementById(user);
//                if (table == null) {
//                    $('#assistanceRow').remove();
//                    createIDTable(user);
//                } else {
//                }
        }

        //function createIDTable(data) {
        //            $('#tbody').append(' ' +
        //          '<tr> ' +
        //          '<td> <-id>' +
        //          '</td>' +
        //          '<td><-%=estado%>' +
        //          '</td> ' +
        //          '<td><-%=cantidad%>' +
        //          '</td>' +
        //          '<td><-%=pedido.getEntregado()%>' +
        //          '</td>' +
        //          '<td>' +
        //          '<div class="btn-group" role="group" aria-label="..." align="center">' +
        //          '<button type="submit" class="btn btn-default" id=<-%=id%> name="entregar">Entregar</button>'   +
        //          '</div>' +
        //          '</td>' +
        //          '</tr>');
        //}

        function window_onload() {
            openSocketPP();
        }

        function writeResponse(text) {
            console.log(text);
        }

        $(document).ready(function () {
            $("button").click(function (event) {
                var name = $(this).attr('id');
                $.post('../restauran3/displaypedidos', {
                    id: name
                });
            });
        });

    </script>
</head>

<body onload="window_onload();">

<form id="reg-form" action="../restauran3/displaypedidos" method="post">
    <br>
    <div class="center-block panel panel-primary" style="width:50%;text-align: center">
        <div class="panel-heading">
            <h3 align="center">Mesas</h3>
        </div>
        <% List<Mesa> mesas = (List<Mesa>) request.getAttribute("mesas");
            Orden orden = null;
            List<Pedido> pedidos = new ArrayList<>();
            if (mesas.isEmpty()) {%>

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
                    <td>
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit" class="btn btn-default" id=<%=id%> name="entregar">Entregar</button>
                        </div>
                    </td>
                </tr>


                    <%}%>
        </div>
        <%
                }
            }
        %>

        </table>


        <%}%>

        <%if (!pedidos.isEmpty()) {%>
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
