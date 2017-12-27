<%@ page import="securityfilter.Constants" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Pedido" %>
<%@ page import="servlets.ClosePedidosServlet" %>
<%@ page import="tables.Menu" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Pedidos</title>
    <% String username = request.getUserPrincipal().getName();%>
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
                if (event.data == "pedido") {
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

        function writePedidoResponse(text) {
            location.reload();
        }

        function window_onload() {
            openSocketP();
            $(document).ready(function () {
                var a = $('.link-1')[1];
                a.parentElement.className = 'active';
            });
        }

        //$(document).ready(function () {
        //  $("button[name='eliminar']").click(function (event) {
        //    location.reload();
        //});
        //});

    </script>

</head>

<jsp:include page="userHome.jsp"></jsp:include>

<body onload="window_onload();">
<div class="row">
    <div class="col s12">
        <form id="reg-form" action="../restauran3/closepedidos" method="post">
            <% List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
                if (!pedidos.isEmpty()) {
            %>
            <div class="center-block panel panel-primary" style="width:85%;text-align: center">
                <div class="panel-heading">
                    <div class="card-panel white">
                        <div class="card-content black-text">
                            <span class="card-title" style="font-size: 1.5em;">Pedidos actuales</span>
                        </div>
                    </div>
                </div>

                <table align="center" class="table striped" width="80%" style="overflow-x:auto; text-align: center;" bgcolor="white">
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

                <div align="center">
                    <table>
                        <td>
                            <div class="btn-group" role="group" aria-label="..." align="center">
                                <button type="submit" class="btn btn-default light-blue darken-3" name="cerrar" id="cerrar"
                                        onclick="sendPedido()">Cerrar Pedido
                                </button>
                            </div>
                        </td>
                        <td>
                            <div class="btn-group" role="group" aria-label="..." align="center">
                                <button type="submit" class="btn btn-default light-blue darken-3" name="eliminar" id="eliminar">Eliminar
                                </button>
                            </div>
                        </td>
                    </table>
                </div>
            </div>
        </form>

        <%}%>

        <% List<Pedido> alaespera = (List<Pedido>) request.getAttribute("alaespera");
            if (!alaespera.isEmpty()) {
        %>

        <div class="center-block panel panel-primary" style="width:85%;text-align: center">
            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Pedidos a la espera de ser entregados</span>
                    </div>
                </div>
            </div>

            <table align="center" class="table striped" width="80%" style="overflow-x:auto; text-align: center;" bgcolor="white">
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
        <div class="center-block panel panel-primary" style="width:85%;text-align: center">

            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Pedidos ya entregados</span>
                    </div>
                </div>
            </div>

            <table align="center" class="table striped" width="80%" style="overflow-x:auto; text-align: center;" bgcolor="white">
                <tr style="font-weight: bold;">
                    <td>Articulo</td>
                    <td>Cantidad</td>
                    <td>Precio</td>
                    <td>Total Parcial</td>
                </tr>
                <% for (Pedido pedido : entregados) {
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
        </div>

        <%}%>

        <% if ((pedidos.isEmpty() && alaespera.isEmpty()) && entregados.isEmpty()) {%>
        <div class="panel panel-default">
            <div class="panel-body">
                <h3 align="center"><span class="label label-primary">No hay pedidos.</span></h3>
            </div>
        </div>
        <%}%>

    </div>
</div>
</body>
</html>