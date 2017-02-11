<%@ page import="tables.Mesa" %>
<%@ page import="java.util.List" %>
<%@ page import="securityfilter.Constants" %>
<%@ page import="tables.Orden" %><%--
  Created by IntelliJ IDEA.
  User: Tomas
  Date: 4/20/2016
  Time: 4:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Ver Mesas</title>
    <script src="/restauran3/js/util/jquery-1.12.3.js"></script>
    <script src="/restauran3/js/util/jquery-ui.js"></script>


    <script>
        $(document).ready(function () {
            $('#add').click(function (event) {
                event.preventDefault();
                var mesaVar = $('#mesa').val();
                var tokenVar = $('#token').val();
                var actionVar = "add";
                $.post('../restauran3/displaytables', {
                    mesa: mesaVar,
                    token: tokenVar,
                    action: actionVar
                }, function (responseText) {
                    var id = '' + responseText.token + '';
                    if (id.valueOf() == "mesa duplicada") {
                        alert("Ya existe la mesa con id: " + responseText.id);
                    } else if (id.valueOf() == "dato vacio") {
                        alert("Campo ID/Token en blanco");
                    }
                    else {
                        $('#tables tr:last').after('<tr><td>' + responseText.id + '</td><td><input type="text" name=' + responseText.token + ' value=' + responseText.token + '></td><td> <input type="radio" name="radio" id=' + responseText.id + ' value=' + responseText.id + '> </td> </tr>');
                        $('#mesa').val("");
                        $('#token').val("");
                    }
                });
            });
            $('#edit').click(function (event) {
                event.preventDefault();
                var selectedVar = $("input[type='radio'][name='radio']:checked").val();
                var actionVar = "edit";
                var $row = $("tr[data-id='" + selectedVar + "']");
                $.post('../restauran3/displaytables', {
                    selected: selectedVar,
                    action: actionVar,
                    newToken: $row.find("input[type=text]").val()
                }, function (responseText) {
                    var id = '' + responseText.id + '';
                    if (id.valueOf() == "no selected") {
                        alert("Debe seleccionar que mesa desea editar");
                    } else {
                        alert(selectedVar + " editada con exito");
                    }
                });
            });
            $('#delete').click(function (event) {
                event.preventDefault();
                var selectedVar = $("input[type='radio'][name='radio']:checked").val();
                var actionVar = "delete";
                var statusVar = confirm('¿Realmente desea borrar la mesa seleccionada?');
                $.post('../restauran3/displaytables', {
                    selected: selectedVar,
                    action: actionVar,
                    status: statusVar
                }, function (responseText) {
                    var id = '' + responseText.id + '';
                    if (id.valueOf() == "no selected") {
                        alert("Debe seleccionar que mesa quiere borrar");
                    } else if (statusVar) {
                        location.reload();
                    }

                });
            });
        });
    </script>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

</head>

<jsp:include page="adminHome.jsp"></jsp:include>

<body>

<form id="reg-form" action="../restauran3/displaytables" method="post">

    <h3 align="center"><span class="label label-primary">Agregar Mesas</span></h3>
    <br>
    <table align="center">
        <tr data-id="agregar">
            <div>

                <td>
                    <div class="input-group">
                        <span class="input-group-addon" id="basic-addon1">ID</span>
                        <input type="text" class="form-control" id="mesa" name="mesa" spellcheck="false"
                               aria-describedby="basic-addon1">
                    </div>
                </td>

                <td>
                    <div class="input-group">
                        <span class="input-group-addon" id="basic-addon2">Token</span>
                        <input type="text" class="form-control" id="token" name="token" spellcheck="false"
                               aria-describedby="basic-addon1">
                    </div>
                </td>

            </div>
        </tr>
    </table>
    <br>
    <div align="center">
        <div class="btn-group" role="group" aria-label="..." align="center">
            <button type="submit" class="btn btn-default" name="add" id="add">Agregar</button>
            <%--<input align="center" type="submit" value="Agregar" name="add" class="button" id="add"/>--%>
        </div>
    </div>
    <br>
</form>

<%--<div class="col-md-12">--%>
    <%--<div class="panel panel-default">--%>
        <%--<div class="panel-heading">--%>
            <%--<h4 class="text-center">Bootstrap Editable jQuery Grid <span class="fa fa-edit pull-right bigicon"></span></h4>--%>
        <%--</div>--%>
        <%--<div class="panel-body text-center">--%>
            <%--<div id="grid"></div>--%>
        <%--</div>--%>
    <%--</div>--%>
<%--</div>--%>



<div class="center-block panel panel-primary" style="width:50%;text-align: center">
    <div class="panel-heading">

        <h3 align="center">Mesas</h3>
    </div>
    <div class="panel-body">
        <table class="table" align="center" width="60%" id="tables">
            <tr>
                <td>Id</td>
                <td>Token</td>
                <td>Select</td>
            </tr>
            <% List<Mesa> data = (List<Mesa>) request.getAttribute("data");
                for (Mesa mesa : data) {
                    String id = mesa.getMesa();
                    String token = mesa.getToken();
            %>
            <tr data-id=<%=id%>>
                <td><%=id%>
                </td>
                </td>
                <td><input type="text" name=<%=token%> value=<%=token%>></td>
                <td><input type=radio name="radio" value=<%=id%>></td>
            </tr>
            <%}%>
        </table>
    </div>

    <div align="center">
        <table>
            <td>
                <div class="btn-group" role="group" aria-label="..." align="center">
                    <button type="submit" class="btn btn-default" name="edit" id="edit">Editar</button>
                </div>
            </td>
            <td>
                <div class="btn-group" role="group" aria-label="..." align="center">
                    <button type="submit" class="btn btn-default" name="delete" id="delete">Borrar</button>
                </div>
            </td>
        </table>
    </div>
<br>

</div>



<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="js/bootstrap.min.js"></script>

</body>
</html>
