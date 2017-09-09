<%@ page import="securityfilter.Constants" %>
<%@ page import="tables.Mesa" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Asistencia</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

    <script type="text/javascript">

        var webSocketAA;
        var ip = "10.10.10.7";

        function openSocketAA() {
            if (webSocketAA !== undefined && webSocketAA.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }
            webSocketAA = new WebSocket("ws://" + ip + ":8080/restauran3/asistencia");

            webSocketAA.onopen = function (event) {
                if (event.data === undefined)
                    return;
                writeResponse(event.data);
            };

            webSocketAA.onmessage = function (event) {
                var parts = event.data.split(" ");
                var action = parts[0];
                var user = parts[1];
                if (action == "asistencia") {
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
            if (table == null) {
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
                    '<button type="submit" class="btn btn-default" name="entregar" id="' + data + '" value="' + data + '"> Asistir </button> ' +
                    '</div> ' +
                    '</td> ' +
                    '</tr>');
        }

        function window_onload() {
            openSocketAA();
        }

        function writeResponse(text) {
            console.log(text);
        }

        $(document).ready(function () {
            $("div.btn-group button[name='entregar']").click(function (event) {
                event.preventDefault();
                var nameVar = $(this).attr('id');
                $.post('../restauran3/displayassistances', {
                    name: nameVar
                }, function () {
                    var row = document.getElementById(nameVar);
                    var table = row.parentNode;
                    table.removeChild(row);
                    if (table.children.length == 0) {
                        $('#tbody').append(' ' +
                                '<tr id="assistanceRow">' +
                                '<td colspan="2" align="center"> ' +
                                '<h3 align="center">' +
                                '<span class="label label-primary">No hay pedidos de asistencia.</span></h3> ' +
                                '</td>' +
                                '</tr>');
                    }
                });
            });
        });

    </script>
</head>

<jsp:include page="adminHome.jsp"/>

<body onload="window_onload();">
<form id="reg-form">
    <br>

    <div class="center-block panel panel-primary" style="width:50%;text-align: center">
        <div class="panel-heading">
            <h3 align="center">Pedidos de asistencia</h3>
        </div>
        <div class="panel panel-default">
            <div class="panel-body">
                <table class="table" align="center" width="60%" id="fields" name="fields">
                    <thead>
                    <tr>
                        <td align="center">ID</td>
                        <td align="center">Estado</td>
                    </tr>
                    </thead>
                    <tbody id="tbody">

                    <% List<Mesa> mesas = (List<Mesa>) request.getAttribute("mesas");
                        if (mesas == null) {%>
                    <tr>
                        <td colspan="2">
                            <h3 align="center"><span class="label label-primary">No hay pedidos de asistencia.</span>
                            </h3>
                        </td>
                    </tr>

                    <%} else if (mesas != null && mesas.isEmpty()) {%>
                    <tr id="assistanceRow">
                        <td colspan="2">
                            <h3 align="center"><span class="label label-primary" id="span" name="span">No hay pedidos de asistencia.</span>
                            </h3>
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
                                <button type="submit" class="btn btn-default" name="entregar" id=<%=id%> value=<%=id%>>
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
        <br>
            <%}%>


</body>

</html>