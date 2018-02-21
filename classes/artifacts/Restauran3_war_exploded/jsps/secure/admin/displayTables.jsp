<%@ page import="org.json.JSONArray" %>
<%@ page import="securityfilter.Constants" %>
<%@ page import="tables.Mesa" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Mesas</title>

    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.css" />
    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid-theme.min.css" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.js"></script>

    <script>
        function window_onload() {
            var a = $('.link-1')[3];
            a.parentElement.className = 'active';
            $(document).ready(function () {

                $("button[name='addTable']").click(function (event) {
                    event.preventDefault();
                    var passwordVar = $('#newTable').val();
                    var actionVar = "add";
                    $.post('../restauran3/displaytables', {password: passwordVar, action: actionVar}, function (responseText) {
                        var data = '' + responseText.status + '';
                        debugger;
                        if (data.valueOf() === "ok") {
                            $('#mesas tr:last').after('' +
                                    '<tr class="row" id='+responseText.id+'>'
                    +'<td class="col s5" style="transform: translateY(120%); overflow-x: auto; text-align: center;" id="nombre"'+responseText.id+'>'
                        +responseText.id+'</td> <td class="col s5" id="precio"'+responseText.id+'> <div> <div class="input-field">'
                            +'<input id="tokenTd'+responseText.id+'" type="text" style="text-align: center;"class="validate" value='+responseText.token+'>'
                            +'<label class="active" name="tokenTd"></label> </div> </div> </td> <td class="col s1">'
                        +'<div id="guardar-container" class="btn-group" role="group" aria-label="..." align="center"> <button type="submit"'
                        +'class="btn btn-floating small light-blue darken-3 tooltipped editarMesaBtn" id="editarMesa" name="editarMesa"'
                            +'style="margin-top: 20px; margin-bottom: 5px;" data-position="top" data-delay="50" data-tooltip="Guardar"'
                            +'value='+responseText.id+'> <i class="material-icons">save</i> </button> </div> </td> <td class="col s1">'
                        +'<div id="eliminar-container" class="btn-group" role="group" aria-label="..." align="center"> <button type="submit"'
                        +'class="btn btn-floating small light-blue darken-3 eliminarMesaBtn"'
                            +'id="eliminarMesa" name="eliminarMesa" style="margin-top: 20px; margin-bottom: 5px;"'
                                 +'value='+responseText.id+'><i class="material-icons">delete</i> </button>'
                        +'</div> </td> </tr>'+'');

                            $('#newTable')[0].value = "";
                        }

                    })
                });

                $('body').on('click','.editarMesaBtn',function (event) {
                    event.preventDefault();
                    var idVar = this.value;
                    var actionVar = "edit";
                    var tokenVar = $('#tokenTd' + this.value).val();
                    $.post('../restauran3/displaytables', {
                        id: idVar,
                        action: actionVar,
                        token: tokenVar
                    }, function (responseText) {
                        var data = '' + responseText.state + '';
                        if (data.valueOf() === "ok") {
                            Materialize.toast('Mesa editada con éxito.', 4000);
                        } else {
                            Materialize.toast('No se pueden dejar campos en blanco.', 4000);
                            $('#tokenTd' + responseText.id).val(responseText.token);
                        }
                    })
                });

                $('body').on('click','.eliminarMesaBtn',function (event) {
                    event.preventDefault();
                    var idVar = this.value;
                    var actionVar = "delete";
                    $.post('../restauran3/displaytables', {id: idVar, action: actionVar}, function (responseText) {
                        var data = '' + responseText.state + '';
                        if (data.valueOf() === "ok") {
                            $('#'+responseText.id).remove();
                            Materialize.toast('Mesa eliminada con éxito.', 4000);
                        }
                    })
                });
            });
        }

    </script>
    <%
        JSONArray json = (JSONArray) request.getAttribute("json");
    %>

</head>

<jsp:include page="adminHome.jsp"></jsp:include>

<body onload="window_onload();">
<div class="row">
    <div class="col s12">
        <div class="center-block panel panel-primary" style="width:85%;text-align: center">

            <div class="panel-heading">
                <div class="card-panel white">
                    <div class="card-content black-text">
                        <span class="card-title" style="font-size: 1.5em;">Mesas</span>
                    </div>
                </div>
            </div>

            <table align="center" class="striped" width="300">
                <tr class="row" style="background-color: white;">
                    <td class="col s3" style="font-weight: bold; height: 80px; line-height: 80px; text-align: center;">Agregar Mesa</td>
                    <td class="col s6">
                        <div>
                            <div class="input-field">
                                <input id="newTable" type="text" class="validate" placeholder="Token">
                                <label class="active"></label>
                            </div>
                        </div>
                    </td>
                    <td class="col s3" style="height: 80px; line-height: 80px; text-align: center;">
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit" class="btn btn-floating small light-blue darken-3 tooltipped"
                                    name="addTable" id="addTable"
                                    data-position="top" data-delay="50" data-tooltip="Agregar mesa"><i class="material-icons">add</i>
                            </button>
                        </div>
                    </td>
                </tr>
            </table>

            <table align="center" class="striped" width="300"
                   style="overflow-x:auto; text-align: center;" id="mesas"
                   bgcolor="white">
                <thead>
                <tr class="row" id="topRow" style="background-color: #d0d0d0;">
                    <th class="col s5" style="text-align: center;">Nombre</th>
                    <th class="col s5" style="text-align: center;">Token</th>
                    <th class="col s1"></th>
                    <th class="col s1"></th>

                </tr>
                </thead>
            <%
                List<Mesa> mesas = (List<Mesa>) request.getAttribute("data");
                for (Mesa mesa : mesas) {
            %>


                <tr class="row" id=<%=mesa.getMesa()%>>

                    <td class="col s5" style="transform: translateY(120%); overflow-x: auto; text-align: center;" id="nombre"<%=mesa.getMesa()%>>
                        <%=mesa.getMesa()%>
                    </td>
                    <td class="col s5" id="precio"<%=mesa.getMesa()%>>
                        <div>
                            <div class="input-field">
                                <input id="tokenTd<%=mesa.getMesa()%>" type="text" style="text-align: center;"
                                       class="validate" value=<%=mesa.getToken()%>>
                                <label class="active" name="tokenTd"></label>
                            </div>
                        </div>
                    </td>
                    <td class="col s1">
                        <div id="guardar-container" class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit"
                                    class="btn btn-floating small light-blue darken-3 tooltipped editarMesaBtn"
                                    id="editarMesa" name="editarMesa"
                                    style="margin-top: 20px; margin-bottom: 5px;"
                                    data-position="top" data-delay="50" data-tooltip="Guardar"
                                    value=<%=mesa.getMesa()%>>
                                <i class="material-icons">save</i>
                            </button>
                        </div>
                        </td>
                    <td class="col s1">
                        <div id="eliminar-container" class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit"
                                    class="btn btn-floating small light-blue darken-3 eliminarMesaBtn"
                                    id="eliminarMesa" name="eliminarMesa" style="margin-top: 20px; margin-bottom: 5px;"
                                    value=<%=mesa.getMesa()%>><i
                                    class="material-icons">delete</i>
                            </button>
                        </div>
                    </td>
                </tr>
                <%}%>
            </table>

            <form id="reg-form" action="../restauran3/displaytables" method="post">
            </form>

        </div>
    </div>
</div>

</body>
</html>
