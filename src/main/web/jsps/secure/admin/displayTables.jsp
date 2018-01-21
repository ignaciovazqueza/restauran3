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
        }

    </script>
    <%
        JSONArray json = (JSONArray) request.getAttribute("json");
    %>
    <script>

        $(function () {

            $("#jsGrid").jsGrid({

                width: "60%",
                align: "center",

                inserting: true,
                filtering: false,
                editing: true,
                sorting: true,
                paging: true,
                autoload: true,

                pageSize: 10,
                pageButtonCount: 2,

                deleteConfirm: function (item) {
                    return "¿Estas seguro que desea borrar la mesa:  \"" + item.mesa + "\" ?";
                },

                controller: {
                    loadData: function (filter) {
                    },
                    insertItem: function (item) {
                        if (item.mesa != "" && item.token != "") {
                            return $.post("../restauran3/displaytables", {
                                name: item.mesa,
                                pass: item.token,
                                action: "add",
                                status: true

                            })
                        } else {
                            // $("#jsGrid").jsGrid("refresh");
                            alert("campo vacio no se agrego la mesa");
                            location.reload();

                        }
                        ;
                    },
                    updateItem: function (item) {
                        if (item.mesa != "" && item.token != "") {
                            return $.post("../restauran3/displaytables", {
                                name: item.mesa,
                                pass: item.token,
                                action: "edit",
                                selected: item.mesa

                            })
                            location.reload();
                        } else {
                            $("#jsGrid").jsGrid("cancelEdit");
                            alert("campo vacio no se realizaron los cambios");
                            location.reload();

                        }
                    },
                    deleteItem: function (item) {
                        return $.post("../restauran3/displaytables", {
                            id: item.mesa,
                            action: "delete",
                            status: true

                        });
                    }

                },

                data: <%=json%>,


                fields: [
                    {name: "mesa", width: 50, align: "center", readOnly: true, valueField: "mesa"},
                    {name: "token", type: "text", width: 20, align: "center"},
                    {type: "control", align: "center", width: 20}
                ]

            });

        });

    </script>

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
                                <input id="newTable" type="text" class="validate">
                                <label class="active"></label>
                            </div>
                        </div>
                    </td>
                    <td class="col s3" style="height: 80px; line-height: 80px; text-align: center;">
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit" class="btn btn-floating small light-blue darken-3 tooltipped"
                                    name="addTable" id="addTable"
                                    data-position="top" data-delay="50" data-tooltip="Agregar categoría"><i class="material-icons">add</i>
                            </button>
                        </div>
                    </td>
                </tr>
            </table>

            <table align="center" class="striped" width="300"
                   style="overflow-x:auto; text-align: center;" id="mesas"
                   bgcolor="white">
                <thead>
                <tr class="row" id="topRow">
                    <th class="col s5">Nombre</th>
                    <th class="col s5">Token</th>
                    <th class="col s1"></th>
                    <th class="col s1"></th>

                </tr>
                </thead>
            <%
                List<Mesa> mesas = (List<Mesa>) request.getAttribute("data");
                for (Mesa mesa : mesas) {
            %>


                <tr class="row" id=<%=mesa.getMesa()%>>

                    <td class="col s5" id="nombre"<%=mesa.getMesa()%>>
                        <%=mesa.getMesa()%>
                    </td>
                    <td class="col s5" id="precio"<%=mesa.getMesa()%>>
                        <div>
                            <div class="input-field">
                                <input id="tokenTd<%=mesa.getMesa()%>" type="text"
                                       class="validate" value=<%=mesa.getToken()%>>
                                <label class="active" name="tokenTd"></label>
                            </div>
                        </div>
                    </td>
                    <td class="col s1">
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit"
                                    class="btn btn-floating small light-blue darken-3 tooltipped"
                                    id="editarMenu" name="editarMesa"
                                    style="margin-top: 5px; margin-bottom: 5px;"
                                    data-position="top" data-delay="50" data-tooltip="Guardar"
                                    value=<%=mesa.getMesa()%>>
                                <i class="material-icons">save</i>
                            </button>
                        </div>
                        </td>
                    <td class="col s1">
                        <div class="btn-group" role="group" aria-label="..." align="center">
                            <button type="submit"
                                    class="btn btn-floating small light-blue darken-3 "
                                    id="eliminarMenu" name="eliminarMesa" style="margin-bottom: 5px;"
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
