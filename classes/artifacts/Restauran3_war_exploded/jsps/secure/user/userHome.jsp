<%@ page import="securityfilter.Constants" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>User</title>
    <link rel="stylesheet" href="/restauran3/css/topMenu.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="/restauran3/materialize/css/materialize.min.css">
    <link rel="stylesheet" href="/restauran3/css/jquery-ui.css">
    <link rel="shortcut icon" href="/restauran3/images/Restauran3-logo.png"/>

    <script src="/restauran3/js/util/jquery-3.2.1.js"></script>
    <script src="/restauran3/js/util/jquery-ui.js"></script>
    <script src="/restauran3/materialize/js/materialize.min.js"></script>

    <script>
        $(document).ready(function () {
            $('.button-collapse').sideNav({
                    menuWidth: 240,
                    edge: 'left',
                    closeOnClick: true
                }
            );
            $('.modal').modal();
        });

        function openModal1() {
            $('#modal1').modal('open');
        }

        function openModal2() {
            $('#modal2').modal('open');
        }
    </script>
</head>

<body>
<div id="modal1" class="modal">
    <div class="modal-content">
        <h4>Restauran3</h4>
        <p>Realmente desea de salir del sistema?</p>
    </div>
    <div class="modal-footer">
        <a href="/restauran3/jsps/outroPage.jsp" class="modal-action modal-close btn-flat">OK</a>
        <a href="#!" class="modal-action modal-close btn-flat">Cancelar</a>
    </div>
</div>

<div id="modal2" class="modal">
    <div class="modal-content">
        <h4>Restauran3</h4>
        <p>Realmente desea pedir la cuenta? Si clickea en OK, se procedera en quitarlo del sistema.</p>
    </div>
    <div class="modal-footer">
        <form id="reg-form" action="../restauran3/closetable" method="post">
            <button type="submit" class="modal-action modal-close btn-flat">OK</button>
            <button type="reset" class="modal-action modal-close btn-flat">Cancelar</button>
        </form>
    </div>
</div>

<div class="col s12">
    <nav>
        <div class="nav-wrapper light-blue darken-3">
            <a href="#!" data-activates="slide-out" class="button-collapse"><i class="material-icons">menu</i></a>
            <ul class="left hide-on-med-and-down">
                <li><img class="circle" alt="" src="/restauran3/images/Restauran3-logo.png"
                         style="width: 50px; height: 50px; margin-top: 8px; margin-left: 10px"></li>
            </ul>
            <ul class="right hide-on-med-and-down">
                <li><a class="link-1" href="${pageContext.request.contextPath}/orderitem">Hacer pedido</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/closepedidos">Ver pedidos</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/askassistance">Pedir asistencia</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/closetable">Pedir cuenta</a></li>
                <li><a class="link-1" href="#modal1" onclick="openModal1()">Salir</a></li>
            </ul>
            <ul id="slide-out" class="side-nav">
                <li>
                    <div class="user-view">
                        <div class="background nav-wrapper light-blue darken-3" style="height: 130px"></div>
                        <div>
                            <img class="circle" alt="" src="/restauran3/images/Restauran3-logo.png">
                        </div>
                        <span class="white-text name" style="font-size: 2em; display: inline-block">Restauran3</span>
                    </div>
                </li>
                <li style="margin-top: 5px"><a class="link-1" href="${pageContext.request.contextPath}/orderitem">Hacer
                    pedido</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/closepedidos">Ver pedidos</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/askassistance">Pedir asistencia</a></li>
                <li><a class="link-1" href="${pageContext.request.contextPath}/closetable">Pedir cuenta</a></li>
                <li><a class="link-1" href="#modal1" onclick="openModal1()" style="color: #ea0e0e;">Salir</a></li>
            </ul>
        </div>
    </nav>
</div>

</body>
</html>