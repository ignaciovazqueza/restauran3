<%@ page import="tables.Mesa" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Pedido" %>
<%@ page import="tables.Orden" %>
<%@ page import="servlets.DisplayPedidosServlet" %>
<%@ page import="securityfilter.Constants" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="tables.Menu" %>
<%@ page import="servlets.ClosePedidosServlet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Pedidos</title>

    <script type="text/javascript">

        var webSocketPP;
        var ip = "10.10.10.6";

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
                    setTimeout(writeAsistenciaResponsePP(event.data), 1000);
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
            $(document).ready(function () {
                var a = $('.link-1')[0];
                a.parentElement.className = 'active';

                $("button[name='entregar']").click(function (event) {
                    event.preventDefault();
                    var name = $(this).attr('id');
                    var tableVar = this.value;
                    $.post('../restauran3/displaypedidos', { id: name, table: tableVar }, function(responseText){
                        var data = '' + responseText.status + '';
                        if (data.valueOf() === "ok") {

                            var rowCount = $('#pedidos'+responseText.mesa+ '>tbody >tr').length;
                            if (rowCount > 2){
                                debugger;
                                $('#tr'+responseText.id).remove();
                            }else {
                                $('#pedidos'+responseText.mesa).remove();
                                $('#panel'+responseText.mesa).remove();
                                debugger;
                                var data = '' + responseText.tables + '';
                                if (data.valueOf() === "false") {
                                    $('#mesas').append('<div class="panel panel-default"> <div class="card-panel white">'
                                    +'<div class="card-content black-text"> <span class="card-title" style="font-size: 1em;">No hay pedidos.</span>'
                                    +'</div> </div> </div>');
                                }
                            }
                            Materialize.toast('Pedido entregado con éxito.', 4000);
                        } else {
                            Materialize.toast('Error no se pudo entregar.', 4000);
                        }
                    })
                });
            });
        }

        function writeResponse(text) {
            console.log(text);
        }

    </script>
</head>
<jsp:include page="adminHome.jsp"></jsp:include>
<body onload="window_onload();">

<div class="row">
    <div class="col s12">
        <div class="center-block panel panel-primary" style="width:85%;text-align: center" id="mesas">

            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Mesas</span>
                    </div>
                </div>
            </div>

            <form id="reg-form" action="../restauran3/displaypedidos" method="post">

                <% List<Mesa> mesas = (List<Mesa>) request.getAttribute("mesas");
                    Orden orden = null;
                    List<Pedido> pedidos = new ArrayList<>();
                    if (mesas.isEmpty()) {%>

                <div class="panel panel-default">
                    <div class="card-panel white">
                        <div class="card-content black-text">
                            <span class="card-title" style="font-size: 1em;">No hay pedidos.</span>
                        </div>
                    </div>
                </div>

                <%
                    }
                    for (Mesa mesa : mesas) {
                        orden = DisplayPedidosServlet.getOrden(mesa.getMesa());
                        if (orden != null) {
                            pedidos = DisplayPedidosServlet.getPedidos(orden.getIdorden());
                            if (!pedidos.isEmpty()) {
                %>


                <div class="center-block panel panel-primary" style="text-align: center" >

                    <div class="panel-heading" id="panel<%=mesa.getMesa()%>" >
                        <div class="card-panel white">
                            <div class="card-content black-text">
                                <span class="card-title"
                                      style="font-size: 1.5em;"><%=mesa.getMesa().toUpperCase()%></span>
                            </div>
                        </div>
                            <table align="center" class="table striped" id="pedidos<%=mesa.getMesa()%>" width="80%"
                                   style="overflow-x:auto; text-align: center; margin-top: -34px;"
                                   bgcolor="white">
                                <tr>
                                    <th>Pedido</th>
                                    <th>Articulo</th>
                                    <th>Cantidad</th>
                                    <th>Estado</th>
                                    <th></th>
                                </tr>
                                <% for (Pedido pedido : pedidos) {
                                    int id = pedido.getIdPedido();
                                    Menu articulo = ClosePedidosServlet.getArticulo(pedido.getIdArticulo());
                                    String estado = articulo.getNombre();
                                    int cantidad = Integer.parseInt(pedido.getCantidad());
                                %>


                                <tr id="tr<%=id%>">
                                    <td><%=id%>
                                    </td>
                                    <td><%=estado%>
                                    </td>
                                    <td><%=cantidad%>
                                    </td>
                                    <td><%=pedido.getEntregado()%>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group" aria-label="..." align="center">
                                            <button type="submit" class="btn btn-default light-blue darken-3"
                                                    id=<%=id%>  value=<%=mesa.getMesa()%> name="entregar">Entregar
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%}%>

                            </table>
                    </div>

                </div>
                <%
                            }
                        }
                    }
                    if (!pedidos.isEmpty()) {%>
                <%--<div align="center">--%>
                <%--<div class="btn-group" role="group" aria-label="..." align="center">--%>
                <%--<button type="submit" class="btn btn-default" name="entregar">Entregar</button>--%>
                <%--</div>--%>
                <%--</div>--%>

                <%} else {%>
                <div class="panel panel-default">
                    <div class="card-panel white">
                        <div class="card-content black-text">
                            <span class="card-title" style="font-size: 1em;">No hay pedidos.</span>
                        </div>
                    </div>
                </div>
                <%}%>
            </form>
        </div>

    </div>
</div>

</body>

</html>
