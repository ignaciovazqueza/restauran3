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

                $("button[name='eliminar']").click(function (event) {
                    Materialize.toast('El ítem ha sido eliminado con éxito.', 4000);
                    event.preventDefault();
                    var idVar = $('#eliminar').prop("value");
                    var actionVar = "eliminar";
                    $.post('../restauran3/closepedidos', {id: idVar, action: actionVar}, function (responseText) {
                        var rowCount = $('#pedidos >tbody >tr').length;
                        if (rowCount == 2) {
                            $("#pedidosDiv")[0].style.display = 'none';
                            $('#pedidos').remove();
                            $('#cerrarButton').remove();
                            $('#pedidosActuales').remove();
                        } else {
                            var id = $('#eliminar').prop("value");
                            $('#' + id).remove();
                        }
                    })
                });

                $("button[name='cerrar']").click(function (event) {
                    Materialize.toast('¡El pedido ya está en camino!', 4000);
                    event.preventDefault();
                    var actionVar = "cerrar";
                    $.post('../restauran3/closepedidos', {action: actionVar}, function (responseText) {
                        if($('#pedidosEspera')[0] == undefined){
                            $('#titleActuales')[0].innerText = "Pedidos a la espera de ser entregados";
                            $('#titleActuales')[0].id = "titleEspera";
                            $('#pedidos')[0].id = "pedidosEspera";
                            $('#tdEliminar').remove();
                            $('#thEliminar').remove();
                        }
                        else {
                            $('#pedidos tr').each(function () {
                                var articulo = $(this).find("td").eq(0).html();
                                var cantidad = $(this).find("td").eq(1).html();
                                var precio = $(this).find("td").eq(2).html();
                                var total = $(this).find("td").eq(3).html();
                                if (articulo != null) {
                                    $('#pedidosEspera tr:last').after('<tr><td> ' + articulo + '</td><td> ' + cantidad + '</td><td> ' + precio + '</td><td> ' + total + '</td></tr>');
                                }

                            });

                            $("#pedidosDiv")[0].style.display = 'none';
                            $('#pedidos').remove();
                            $('#pedidosActuales').remove();
                        }
                        $('#cerrarButton').remove();
                    })
                });
            });

        }

    </script>

</head>

<jsp:include page="userHome.jsp"></jsp:include>

<body onload="window_onload();">
<div class="row">
    <div class="col s12" id="cols12">
        <% List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
            if (!pedidos.isEmpty()) {
        %>
        <form id="reg-form" action="../restauran3/closepedidos" method="post">
            <div class="center-block panel panel-primary" id="pedidosDiv" style="text-align: center">
                <div class="panel-heading" id="pedidosActuales">
                    <div class="card-panel white">
                        <div class="card-content black-text" id="cardPedidosActuales">
                            <span class="card-title" id="titleActuales" style="font-size: 1.5em;">Pedidos actuales</span>
                        </div>
                    </div>
                    <table align="center" class="table striped" width="80%"
                           style="overflow-x:auto; text-align: center; margin-top: -24px;"
                           bgcolor="white" id="pedidos">
                        <tr>
                            <th>Ítem</th>
                            <th class="tooltipped" data-position="top" data-delay="50" data-tooltip="Cantidad">Cant.
                            </th>
                            <th>Precio</th>
                            <th class="tooltipped" data-position="top" data-delay="50" data-tooltip="Precio x Cantidad">
                                Parcial
                            </th>
                            <th id="thEliminar"></th>
                        </tr>
                        <% for (Pedido pedido : pedidos) {
                            int id = pedido.getIdPedido();
                            Menu articulo = ClosePedidosServlet.getArticulo(pedido.getIdArticulo());
                            String estado = articulo.getNombre();
                            int cantidad = Integer.parseInt(pedido.getCantidad());
                            int precio = articulo.getPrecio();
                            int total = cantidad * precio;
                        %>

                        <tr id=<%=id%>>
                            <td><%=estado%>
                            </td>
                            <td><%=cantidad%>
                            </td>
                            <td>$<%=precio%>
                            </td>
                            <td>$<%=total%>
                            </td>
                            <td id="tdEliminar">
                                <div class="btn-group" role="group" aria-label="..." align="center">
                                    <button type="submit" class="btn btn-floating light-blue darken-3" name="eliminar"
                                            value=<%=id%> id="eliminar"><i class="material-icons">delete</i>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <%}%>

                    </table>
                    <div align="center">
                        <table>
                            <td>
                                <div class="btn-group" role="group" aria-label="..." align="center" id="cerrarButton">
                                    <button type="submit" class="btn btn-default light-blue darken-3" name="cerrar"
                                            id="cerrar">Cerrar Pedido
                                    </button>
                                </div>
                            </td>

                        </table>
                    </div>
                </div>

            </div>
        </form>
        <%}%>

        <% List<Pedido> alaespera = (List<Pedido>) request.getAttribute("alaespera");
            if (!alaespera.isEmpty()) {
        %>

        <div class="center-block panel panel-primary" style="text-align: center">
            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Pedidos a la espera de ser entregados</span>
                    </div>
                </div>
                <table align="center" class="table striped" width="80%"
                       style="overflow-x:auto; text-align: center; margin-top: -24px;"
                       bgcolor="white" id="pedidosEspera">
                    <tr>
                        <th>Ítem</th>
                        <th class="tooltipped" data-position="top" data-delay="50" data-tooltip="Cantidad">Cant.</th>
                        <th>Precio</th>
                        <th class="tooltipped" data-position="top" data-delay="50" data-tooltip="Precio x Cantidad">
                            Parcial
                        </th>
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
            </div>

        </div>
        <br>

        <%
            }
            List<Pedido> entregados = (List<Pedido>) request.getAttribute("entregados");
            if (!entregados.isEmpty()) {
        %>
        <div class="center-block panel panel-primary" style="text-align: center;">

            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Pedidos ya entregados</span>
                    </div>
                </div>
                <table align="center" class="table striped" width="80%"
                       style="overflow-x:auto; text-align: center; margin-top: -24px;"
                       bgcolor="white">
                    <tr style="font-weight: bold;">
                        <th>Ítem</th>
                        <th class="tooltipped" data-position="top" data-delay="50" data-tooltip="Cantidad">Cant.</th>
                        <th>Precio</th>
                        <th class="tooltipped" data-position="top" data-delay="50" data-tooltip="Precio x Cantidad">
                            Parcial
                        </th>
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

        </div>

        <%}%>

        <% if ((pedidos.isEmpty() && alaespera.isEmpty()) && entregados.isEmpty()) {%>
        <div class="panel panel-default" style="margin-left: 10px;margin-right: 10px;">
            <div class="card-panel white">
                <div class="card-content black-text">
                    <span class="card-title" style="font-size: 1em;">No hay pedidos.</span>
                </div>
            </div>
        </div>
        <%}%>

    </div>
</div>
</body>
</html>