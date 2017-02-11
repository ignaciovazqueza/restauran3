<%@ page import="java.util.List" %>
<%@ page import="securityfilter.Constants" %>
<%@ page import="tables.*" %>
<%@ page import="servlets.DisplayAsisstancesServlet" %>
<%--
  Created by IntelliJ IDEA.
  User: Tomas
  Date: 5/10/2016
  Time: 5:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Asistencia</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
</head>

<jsp:include page="adminHome.jsp"></jsp:include>

<body>
<form id="reg-form" action="../restauran3/displayassistances" method="post">
    <br>
    <div class="center-block panel panel-primary" style="width:50%;text-align: center">
        <div class="panel-heading">
            <h3 align="center">Mesas</h3>
        </div>

        <%  List<Mesa> mesas = (List<Mesa>) request.getAttribute("mesas");
            if(mesas == null) {%>
    <div class="panel panel-default">
        <div class="panel-body">
            <h3 align="center"><span class="label label-primary">No hay pedidos de asistencia.</span></h3>
        </div>
    </div>
        <%} else if (mesas != null && mesas.isEmpty()){%>
    <div class="panel panel-default">
        <div class="panel-body">
            <h3 align="center"><span class="label label-primary">No hay pedidos de asistencia.</span></h3>
        </div>
    </div>
        <%} else if (mesas != null && !mesas.isEmpty()){%>

    <br>

            <% for (Mesa mesa : mesas){ %>

        <div class="panel-body">
            <h3 align="center"><span class="label label-primary"><%=mesa.getMesa().toUpperCase()%></span></h3>
            <table class="table" align="center" width="60%">

                <tr>
                    <td>ID</td>
                    <td>Estado</td>

                </tr>
                <% String id = mesa.getMesa();
                    String estado = mesa.getAsistencia(); %>


                <tr>
                    <td><%=id%>
                    </td>
                    <td><%=estado%>
                    </td>
                    <td><input align="center" type=checkbox name=check id=<%=id%> value=<%=id%>></td>
                </tr>

            </table>
            <%}%>
        </div>
        <br>
        <div align="center">
            <div class="btn-group" role="group" aria-label="..." align="center">
                <button type="submit" class="btn btn-default" name="entregar">Asistir</button>
            </div>
        </div>
        <br>
</div>

            <%}%>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
</body>

</html>
