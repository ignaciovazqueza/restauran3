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
        var ip = "10.10.10.8";

        function openSocketA() {

            if (webSocketA !== undefined && webSocketA.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }

            webSocketA = new WebSocket("ws://" + ip + ":8080/restauran3/asistencia");

            webSocketA.onopen = function (event) {
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

        function sendAsistencia() {
        //    var user = "";
         //   user = $('#user').value;
            var user = document.getElementById('user').value;
            var text = "asistencia " + user;
            webSocketA.send(text);
        }

        function closeSocketA() {
            webSocketO.close();
        }

        function writeResponse(text) {
            console.log(text);
        }

        function writeAsistenciaResponse(text){
            location.reload();
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
