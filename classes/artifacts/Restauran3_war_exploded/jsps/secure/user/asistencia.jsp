<%@ page import="securityfilter.Constants" %>
<%@ page import="java.net.InetAddress" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Asistencia</title>
    <% String username = request.getUserPrincipal().getName();
       InetAddress localHost = InetAddress.getLocalHost();
       String ip = localHost.getHostAddress();
    %>
    <input type="hidden" value="<%=username%>" id="user">
    <script type="text/javascript" src="/restauran3/js/util/ip.js"></script>

    <script type="text/javascript">

        var webSocketA;
        var myIp = "<%=ip%>";

        function openSocketA() {

            if (webSocketA !== undefined && webSocketA.readyState !== WebSocket.CLOSED) {
                writeResponse("WebSocket is already opened.");
                return;
            }

            webSocketA = new WebSocket("ws://" + myIp + ":8080/restauran3/asistencia");

            webSocketA.onopen = function (event) {
                if (event.data === undefined)
                    return;
                writeResponse(event.data);
            };

            webSocketA.onmessage = function (event) {
                if (event.data == "asistencia") {
                    writeAsistenciaResponse(event.data);
                    $('#asistencia')[0].className = $('#asistencia')[0].className.substring(0, 35);
                }
            };

            webSocketA.onclose = function (event) {
                writeResponse("Connection closed");
            };
        }

        function sendAsistencia() {
            //    var user = "";
            //   user = $('#user').value;
            $('#asistencia')[0].className += " disabled";
            var user = document.getElementById('user').value;
            var text = "asistencia " + user;
            webSocketA.send(text);
        }

        function closeSocketA() {
            webSocketA.close();
        }

        function writeResponse(text) {
            console.log(text);
        }

        function writeAsistenciaResponse(text) {
            setTimeout(location.reload(),1000);
        }

        function window_onload() {
            openSocketA();
            $(document).ready(function () {
                var a = $('.link-1')[2];
                a.parentElement.className = 'active';

                if ($('#nombre')[0].innerText == "Asistencia en camino"){
                    $('#asistencia')[0].className += " disabled";
                }

                $("button[name='asistencia']").click(function (event) {
                    Materialize.toast('¡La asistencia está en camino!', 4000);
                    event.preventDefault();
                    $.post('../restauran3/askassistance', {}, function (responseText) {
                        $('#nombre').html('Asistencia en camino');
                    })
                });

            });
        }


    </script>

</head>

<jsp:include page="userHome.jsp"></jsp:include>

<body onload="window_onload();" style="height: 100%;">

<% String estado = (String) request.getAttribute("estado");%>

<div class="row">
    <div class="col s12">
        <div class="center-block panel panel-primary" style="text-align: center">
            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Estado</span>
                    </div>
                </div>
            </div>

            <form id="reg-form" action="../restauran3/askassistance" method="post">
                <div class="card horizontal">
                    <div class="card-stacked">
                        <div class="input-group">
                            <div type="text" class="form-control" style="padding-bottom: 10px; padding-top: 10px"
                                 id="nombre" name="nombre" spellcheck="false"
                                 aria-describedby="basic-addon1" readonly>
                                <%=estado%>
                            </div>
                        </div>
                        <div class="card-action">
                            <div class="btn-group" role="group" aria-label="..." align="center">
                                <button type="submit" class="btn btn-default light-blue darken-3" name="asistencia"
                                        id="asistencia"
                                        onclick="sendAsistencia();">Pedir
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

            </form>
        </div>

    </div>
</div>
</body>
</html>
