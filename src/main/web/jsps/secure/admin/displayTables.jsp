<%@ page import="org.json.JSONArray" %>
<%@ page import="securityfilter.Constants" %>
<%@ page import="tables.Mesa" %>
<%@ page import="java.util.List" %><%--
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
    <script src="/restauran3/js/util/jquery-ui.js"></script>
    <script src="/restauran3/js/util/jquery-3.2.1.js"></script>

    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.css" />
    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid-theme.min.css" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.js"></script>


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
    <%
        JSONArray json = (JSONArray) request.getAttribute("json");
    %>
    <script>

        $(function() {

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

                deleteConfirm: function(item) {
                    return "¿Estas seguro que desea borrar la mesa:  \"" + item.mesa + "\" ?";
                },

                controller: {
                    loadData: function (filter) {
                    },
                    insertItem: function (item) {
                        if (item.mesa != "" && item.token != "" ){
                            return $.post("../restauran3/displaytables", {
                                name: item.mesa,
                                pass: item.token,
                                action: "add",
                                status: true

                            })
                        }else {
                           // $("#jsGrid").jsGrid("refresh");
                            alert("campo vacio no se agrego la mesa");
                            location.reload();

                        };
                    },
                    updateItem: function (item) {
                        if (item.mesa != "" && item.token!= ""){
                            return $.post("../restauran3/displaytables", {
                                name: item.mesa,
                                pass: item.token,
                                action: "edit",
                                selected: item.mesa

                            })
                            location.reload();
                        }else{
                            $("#jsGrid").jsGrid("cancelEdit");
                            alert("campo vacio no se realizaron los cambios");
                            location.reload();

                        }
                    },
                    deleteItem: function (item) {
                        return $.post("../restauran3/displaytables",{
                            id: item.mesa,
                            action: "delete",
                            status: true

                        });
                    }

                },

                data: <%=json%>,



                fields: [
                    { name: "mesa", width: 50 , align: "center", readOnly: true, valueField: "mesa"},
                    { name: "token", type: "text", width: 20, align: "center"},
                    { type: "control" , align: "center", width: 20}
                ]

            });

        });

    </script>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

</head>

<jsp:include page="adminHome.jsp"></jsp:include>

<body>

<form id="reg-form" action="../restauran3/displaytables" method="post">

    <h3 align="center"><span class="label label-primary">Mesas</span></h3>

</form>

<style>
    .center {
        margin: auto;
        width: 100%;
    }
</style>
<div id="jsGrid" align="center" class="center"></div>

<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="js/bootstrap.min.js"></script>

</body>
</html>
