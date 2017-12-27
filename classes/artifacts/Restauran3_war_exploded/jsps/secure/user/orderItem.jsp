<%@ page import="tables.Categoria" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Menu" %>
<%@ page import="securityfilter.Constants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Ordenar</title>

    <% String username = request.getUserPrincipal().getName();%>

    <script type="text/javascript">

        var webSocket;

        function openSocket() {
            if (webSocket !== undefined && webSocket.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            webSocket = new WebSocket("ws://192.168.0.106:8080/restauran3/pedido");

            webSocket.onopen = function (event) {
                if (event.data === undefined)
                    return;

                writeResponse(event.data);
            };

            webSocket.onmessage = function (event) {
                writeResponse(event.data);
            };

            webSocket.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        function send() {
            //  var text = document.getElementById("messageinput").value;
            var text = "pedido ";
            webSocket.send(text);
        }

        function sendPedido() {
            var user = "";
            user = $('#user').val();
            var text = "pedido";
            webSocket.send(text);
        }

        function closeSocket() {
            webSocket.close();
        }

        function writeResponse(text) {
            //   messages.innerHTML += "<br/>" + text;
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

        <div class="center-block panel panel-primary" style="width:85%;text-align: center">

            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Elija la cantidad de cada artículo</span>
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

                                    <th> Nombre</th>
                                    <th>Precio</th>
                                    <th>Cantidad</th>
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

