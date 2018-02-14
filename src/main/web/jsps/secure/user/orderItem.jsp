<%@ page import="tables.Categoria" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Menu" %>
<%@ page import="securityfilter.Constants" %>
<%@ page import="java.net.InetAddress" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Ordenar</title>
    <script type="text/javascript" src="/restauran3/js/util/ip.js"></script>

    <% String username = request.getUserPrincipal().getName();
       InetAddress localHost = InetAddress.getLocalHost();
       String ip = localHost.getHostAddress();
    %>

    <script type="text/javascript">

        window.onunload = function () {
            closeSocket();
        };

        var webSocketPedido;
        var myIp = "<%=ip%>";

        function openSocket() {
            if (webSocketPedido !== undefined && webSocketPedido.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            webSocketPedido = new WebSocket("ws://" + myIp + ":8080/restauran3/pedido");

            webSocketPedido.onopen = function (event) {
                if (event.data === undefined)
                    return;

                writeResponse(event.data);
            };

            webSocketPedido.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        function sendPedido() {
            var user = "";
            user = $('#user').val();
            var text = "pedido";
            webSocketPedido.send(text);
        }

        function closeSocket() {
            webSocketPedido.close();
        }

        function writeResponse(text) {
            console.log(text);
        }

        function window_onload() {
            openSocket();
            $(document).ready(function () {
                var a = $('.link-1')[0];
                a.parentElement.className = 'active';
            });
        }

    </script>

</head>

<jsp:include page="userHome.jsp"></jsp:include>

<body onload="window_onload();">

<div class="row">
    <div class="col s12">

        <div class="center-block panel panel-primary" style="text-align: center">

            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Elija la cantidad de cada ítem</span>
                    </div>
                </div>
            </div>

            <form id="reg-form" action="../../restauran3/orderitem" method="post">
                <ul class="collapsible" data-collapsible="accordion">
                    <% List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
                        for (Categoria categoria : categorias) {
                    %>

                    <style>
                        #
                        <%=categoria.getNombre()%>
                        ,
                        #table {
                            padding: 5px;
                            text-align: center;
                            background-color: #1b6595;
                            border: solid 1px #c3c3c3;
                            color: white;
                            width: 10%;
                        }
                    </style>

                    <li>
                        <div class="collapsible-header active center-align"
                             style="background-color: #1b6595; color: white;" id=<%=categoria.getNombre()%>>
                            <%=categoria.getNombre()%>
                        </div>
                        <div class="collapsible-body active" id="panel<%=categoria.getNombre()%>"
                             style="padding: 0rem;">
                            <table align="center" class="striped" width="300"
                                   style="overflow-x:auto; text-align: center;" id="table" bgcolor="white">
                                <tr>

                                    <th>Ítem</th>
                                    <th>Precio</th>
                                    <th class="tooltipped" data-position="top" data-delay="50" data-tooltip="Cantidad">Cant.</th>
                                </tr>
                                <% List<Menu> data = (List<Menu>) request.getAttribute("data");
                                    for (Menu menu : data) {
                                        if (menu.getCategoria().equals(categoria.getNombre())) {
                                            int id = menu.getIdArticulo();
                                %>
                                <tr class="tabla">

                                    <td style="padding-bottom: 0px; padding-top: 0px;"><%=menu.getNombre()%>
                                    </td>
                                    <td style="padding-bottom: 0px; padding-top: 0px;"><%=menu.getPrecio()%>
                                    </td>
                                    <td style="padding-bottom: 0px; padding-top: 0px;">
                                        <div>
                                            <label for=<%=id%>></label>
                                            <input type="number" min="1" pattern="[0-9]*" inputmode="numeric"
                                                   id=<%=id%> name="<%=id%>" spellcheck="false"/>
                                        </div>
                                    </td>
                                </tr>
                                <%}%>
                                <%}%>
                            </table>
                        </div>
                    </li>

                    <%}%>
                </ul>
                <div align="center">
                    <div class="btn-group" role="group" aria-label="..." align="center">
                        <button type="submit" class="btn btn-default light-blue darken-3" id="order-item"
                                name="entregar"
                                onclick="sendPedido();">Ordenar!
                        </button>
                    </div>
                </div>
                <br>

            </form>
        </div>
    </div>
</div>
</body>
</html>

