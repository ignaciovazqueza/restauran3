<%@ page import="securityfilter.Constants"%>
<%@ page import="tables.Orden" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>User</title>
    <link rel="stylesheet" href="/restauran3/css/topMenu.css">

    <% String username = request.getUserPrincipal().getName();%>

    <script type="text/javascript">

        var webSocket;
        var messages = document.getElementById("messages");


        function openSocket(){
            // Ensures only one connection is open at a time
            if(webSocket !== undefined && webSocket.readyState !== WebSocket.CLOSED){
                writeResponse("WebSocket is already opened.");
                return;
            }
            // Create a new instance of the websocket
            webSocket = new WebSocket("ws://192.168.0.104:8080/restauran3/websocket");

            /**
             * Binds functions to the listeners for the websocket.
             */
            webSocket.onopen = function(event){
                // For reasons I can't determine, onopen gets called twice
                // and the first time event.data is undefined.
                // Leave a comment if you know the answer.
                if(event.data === undefined)
                    return;

                writeResponse(event.data);
            };

            webSocket.onmessage = function(event){
                writeResponse(event.data);
            };

            webSocket.onclose = function(event){
                writeResponse("Connection closed");
            };
        }

        /**
         * Sends the value of the text input to the server
         */
        function send(){
            //  var text = document.getElementById("messageinput").value;
            var username = <%=username%>;
            var text = "asistencia " + username;
            webSocket.send(text);
        }

        function closeSocket(){
            webSocket.close();
        }

        function writeResponse(text){
            messages.innerHTML += "<br/>" + text;
        }

        function window_onload(){
            openSocket();
        }

    </script>

</head>
<body onload="window_onload();">

<nav id="nav-1">

    <a class="link-1" href="${pageContext.request.contextPath}/orderitem">Hacer pedido</a>

    <a class="link-1" href="${pageContext.request.contextPath}/closepedidos">Ver pedidos</a>

    <a class="link-1" href="${pageContext.request.contextPath}/askassistance" onclick="send();">Pedir asistencia</a>

    <a class="link-1" href="${pageContext.request.contextPath}/closetable">Pedir cuenta</a>

    <a class="link-1" href="${pageContext.request.contextPath}/logout"
       onclick="return confirm('Realmente desea salir del sistema?')">Salir</a>
</nav>




</body>
</html>