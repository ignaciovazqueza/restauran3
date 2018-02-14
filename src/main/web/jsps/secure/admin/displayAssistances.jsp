<%@ page import="securityfilter.Constants" %>
<%@ page import="tables.Mesa" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.InetAddress" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Asistencia</title>
    <script type="text/javascript" src="/restauran3/js/util/ip.js"></script>

    <% InetAddress localHost = InetAddress.getLocalHost();
       String ip = localHost.getHostAddress();
    %>

    <script type="text/javascript">

        var webSocketAA;
        var myIp = "<%=ip%>";

        function openSocketAA() {
            if (webSocketAA !== undefined && webSocketAA.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            webSocketAA = new WebSocket("ws://" + myIp + ":8080/restauran3/asistencia");

            webSocketAA.onopen = function (event) {
                if (event.data === undefined)
                    return;
                writeResponse(event.data);
            };

            webSocketAA.onmessage = function (event) {
                var parts = event.data.split(" ");
                var action = parts[0];
                var user = parts[1];
                if (action === "asistencia") {
                    writeAsistenciaResponseAA(event.data);
                }
            };

            webSocketAA.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        function send() {
        }

        function closeSocketAA() {
            webSocketAA.close();
        }

        function writeAsistenciaResponseAA(text) {
            var parts = text.split(" ");
            var action = parts[0];
            var user = parts[1];
            var table = document.getElementById(user);
            if (table === null) {
                $('#assistanceRow').remove();
                createIDTable(user);
            }
        }

        function createIDTable(data) {
            $('#tbody').append(' ' +
                '<tr id="' + data + '"> ' +
                '<td align="center">' + data + '</td> ' +
                '<td align="center">Asistir mesa</td> ' +
                '<td align="center"> ' +
                '<div class="btn-group" role="group" aria-label="..." align="center"> ' +
                '<button type="submit" class="btn btn-default light-blue darken-3" name="entregar" id="' + data + '" value="' + data + '"> Asistir </button> ' +
                '</div> ' +
                '</td> ' +
                '</tr>');
        }

        function window_onload() {
            openSocketAA();
            $(document).ready(function () {
                var a = $('.link-1')[1];
                a.parentElement.className = 'active';
                $("div.btn-group button[name='entregar']").click(function (event) {
                    event.preventDefault();
                    var nameVar = $(this).attr('id');
                    $.post('../restauran3/displayassistances', {
                        name: nameVar
                    }, function () {
                        var row = document.getElementById(nameVar);
                        var table = row.parentNode;
                        table.removeChild(row);
                        if (table.children.length === 0) {
                            $('#tbody').append(' ' +
                                '<tr id="assistanceRow">' +
                                '<td colspan="3" align="center"> ' +
                                '<span class="card-title" style="font-size: 1em;">No hay pedidos de asistencia.</span>' +
                                '</td>' +
                                '</tr>');
                        }
                    });
                });
            });
        }

        function writeResponse(text) {
            console.log(text);
        }

    </script>
</head>

<jsp:include page="adminHome.jsp"/>

<body onload="window_onload();">

<div class="row">
    <div class="col s12">
        <div class="center-block panel panel-primary" style="width:85%;text-align: center">

            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Pedidos de asistencia</span>
                    </div>
                </div>
            </div>

            <form id="reg-form">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <table align="center" width="85%" id="fields" name="fields">
                            <thead style="background-color: lightgray;">
                                <tr>
                                    <th>ID</th>
                                    <th>Estado</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="tbody" style="background-color: white;">

                                <% List<Mesa> mesas = (List<Mesa>) request.getAttribute("mesas");
                                    if (mesas == null) {%>
                                <tr>
                                    <td colspan="3">
                                        <span class="card-title" style="font-size: 1em;">No hay pedidos de asistencia.</span>
                                    </td>
                                </tr>

                                <%} else if (mesas != null && mesas.isEmpty()) {%>
                                <tr id="assistanceRow">
                                    <td colspan="3">
                                        <span class="card-title" style="font-size: 1em;">No hay pedidos de asistencia.</span>
                                    </td>
                                </tr>

                                <%
                                } else if (mesas != null && !mesas.isEmpty()) {
                                    for (Mesa mesa : mesas) {
                                        String id = mesa.getMesa();
                                        String estado = mesa.getAsistencia();
                                %>
                                <tr id=<%=id%>>
                                    <td align="center"><%=id%>
                                    </td>
                                    <td align="center"><%=estado%>
                                    </td>
                                    <td align="center">
                                        <div class="btn-group" role="group" aria-label="..." align="center">
                                            <button type="submit" class="btn btn-default light-blue darken-3"
                                                    name="entregar" id=<%=id%> value=<%=id%>>
                                                Asistir
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
                <%}%>
            </form>

        </div>
    </div>
</div>

</body>

</html>