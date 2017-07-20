<%@ page import="securityfilter.Constants" %><%--
  Created by IntelliJ IDEA.
  User: tomasvazquez
  Date: 20/7/17
  Time: 00:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Asistencia</title>
    <% String username = request.getUserPrincipal().getName();%>
    <input type="hidden" value="<%=username%>" id="user">
    <script type="text/javascript">

        var webSocketA;
        // var messages = document.getElementById("messages");

        function openSocketA() {
            // Ensures only one connection is open at a time
            if (webSocketA !== undefined && webSocketA.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            // Create a new instance of the websocket
            webSocketA = new WebSocket("ws://192.168.0.104:8080/restauran3/asistencia");

            /**
             * Binds functions to the listeners for the websocket.
             */
            webSocketA.onopen = function (event) {
                // For reasons I can't determine, onopen gets called twice
                // and the first time event.data is undefined.
                // Leave a comment if you know the answer.
                if (event.data === undefined)
                    return;

                writeResponse(event.data);
            };

            webSocketA.onmessage = function (event) {
                if (event.data=="asistencia"){
                    writeAsistenciaResponse(event.data);
                }

            };

            webSocketA.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        /**
         * Sends the value of the text input to the server
         */
        function sendAsistencia() {
            var user = "";
            user = <%=username%>;
            var text = "asistencia " + user;
            webSocketA.send(text);
        }

        function closeSocketA() {
            webSocketO.close();
        }

        function writeResponse(text) {
            //  messages.innerHTML += "<br/>" + text;
            console.log(text);
            //    $('#tabla tr:last').after('<tr><td><input type=text value="' + responseText.nombre + '"id="' + responseText.nombre + '"></td><td><input type=text value="' + responseText.precio + '"id="' + responseText.precio + '"></td><td><input type=radio name="radio"  value=' + responseText.id + ' ></td></tr>');
        }
        function writeAsistenciaResponse(text){
            location.reload()
        }

        function window_onload() {
            openSocketA();
        }

    </script>

</head>

<jsp:include page="userHome.jsp"></jsp:include>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<body onload="window_onload();">



<% String estado = (String) request.getAttribute("estado");%>
<br>
<div class="center-block panel panel-primary" style="width:50%;text-align: center">
    <div class="panel-heading">
        <h3 align="center">Asistencia</h3>
    </div>
    <form id="reg-form" action="../restauran3/askassistance" method="post">
    <table align="center">
        <tr>
            <td>
                <br>
                <div class="input-group">
                    <span class="input-group-addon" id="basic-addon1">Estado </span>
                    <input type="text" class="form-control" id="nombre" name="nombre"
                           value="<%=estado%>" spellcheck="false"
                           aria-describedby="basic-addon1" readonly>
                </div>
                <br>
            </td>
        </tr>
        <tr>
                <br>
                <div class="btn-group" role="group" aria-label="..." align="center">
                    <button type="submit" class="btn btn-default" name="asistencia" id="asistencia" onclick="sendAsistencia();">Pedir Asistencia</button>
                </div>
                <br>
        </tr>
    </table>
    </form>
    </div>
</body>
</html>
