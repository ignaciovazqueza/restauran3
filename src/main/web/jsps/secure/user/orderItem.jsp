<%@ page import="tables.Categoria" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Menu" %>
<%@ page import="securityfilter.Constants" %><%--
  Created by IntelliJ IDEA.
  User: Tomas
  Date: 5/10/2016
  Time: 3:35 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
    <link rel="stylesheet" href="/restauran3/css/jquery-ui.css">
    <script src="/restauran3/js/util/jquery-1.12.3.js"></script>
    <script src="/restauran3/js/util/jquery-ui.js"></script>
    <title><%=Constants.COMMON_TITLE_BASE%>Ordenar</title>

    <% String username = request.getUserPrincipal().getName();%>

    <script type="text/javascript">

        var webSocket;
        var messages = document.getElementById("messages");

        function openSocket() {
            // Ensures only one connection is open at a time
            if (webSocket !== undefined && webSocket.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            // Create a new instance of the websocket
            webSocket = new WebSocket("ws://localhost:8080/restauran3/websocket");

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
                writeResponse(event.data);
            };

            webSocket.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        /**
         * Sends the value of the text input to the server
         */
        function send() {
            //  var text = document.getElementById("messageinput").value;
            var username = <%=username%>;
            var text = "pedido " + username;
            webSocket.send(text);
        }

        function closeSocket() {
            webSocket.close();
        }

        function writeResponse(text) {
            messages.innerHTML += "<br/>" + text;
        }

        function window_onload() {
            openSocket();
        }

    </script>

</head>

<jsp:include page="userHome.jsp"></jsp:include>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<body>
<br>
<br>
<div class="center-block panel panel-primary" style="width:50%;text-align: center">
    <div class="panel-heading">
        <h3 align="center">Elija la cantidad que desea de cada artículo:</h3>
    </div>
    <form id="reg-form" action="../../restauran3/orderitem" method="post">
        <% List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
            for (Categoria categoria : categorias) {
        %>
        <script>
            $(document).ready(function () {
                $("#panel<%=categoria.getNombre()%>").hide();
                $("#<%=categoria.getNombre()%>").click(function () {
                    $("#panel<%=categoria.getNombre()%>").slideToggle("slow");
                });
            });
        </script>

        <style>
            #
            <%=categoria.getNombre()%>
            ,
            #flip {
                padding: 5px;
                text-align: center;
                background-color: #337ab7;
                border: solid 1px #c3c3c3;
                color: white;
            }

        </style>

        <div id=<%=categoria.getNombre()%>><%=categoria.getNombre()%>
        </div>
        <div id="panel<%=categoria.getNombre()%>">
            <table align="center" class="table" width="60%">
                <tr>

                    <td><%= "Nombre"%>
                    </td>
                    <td><%= "Precio"%>
                    </td>
                    <td><%= "Cantidad"%>
                    </td>
                </tr>
                <% List<Menu> data = (List<Menu>) request.getAttribute("data");
                    for (Menu menu : data) {
                        if (menu.getCategoria().equals(categoria.getNombre())) {
                            int id = menu.getIdArticulo();
                %>
                <tr class="tabla">

                    <td><%=menu.getNombre()%>
                    </td>
                    <td><%=menu.getPrecio()%>
                    </td>
                    <td>

                        <div>
                            <label for=<%=id%>></label>
                            <input type="number" min="1" id=<%=id%> name="<%=id%>" spellcheck="false"/>
                        </div>
                    </td>
                </tr>
                <%}%>
                <%}%>
            </table>
        </div>

        <%}%>
        <br>
        <div align="center">
            <div class="btn-group" role="group" aria-label="..." align="center">
                <button type="submit" class="btn btn-default" id="order-item" name="entregar" onclick="send();">Ordenar!</button>
            </div>
        </div>
        <br>


        <%--<input type="submit" value="Ordenar!" id="order-item" class="button"/>--%>
    </form>

</body>
</html>

