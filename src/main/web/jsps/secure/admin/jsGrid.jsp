<%@ page import="java.util.List" %>
<%@ page import="tables.Menu" %>
<%@ page import="securityfilter.Constants" %>
<%@ page import="tables.Categoria" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.json.JSONArray" %>
<%--
  Created by IntelliJ IDEA.
  User: Tomas
  Date: 4/7/2016
  Time: 7:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="/restauran3/css/jquery-ui.css">
    <script src="/restauran3/js/util/jquery-3.2.1.js"></script>
    <script src="/restauran3/js/util/jquery-ui.js"></script>

    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.css" />
    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid-theme.min.css" />

    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.js"></script>


    <title><%=Constants.COMMON_TITLE_BASE%>Ver Menu</title>

    <%
        List<Categoria> categoriasAuto = (List<Categoria>) request.getAttribute("categorias");
        List<String> categories = new ArrayList<>(categoriasAuto.size());
        for (int i = 0; i < categoriasAuto.size(); i++) {
            categories.add(categoriasAuto.get(i).getNombre());
        }
        JSONArray jsonArray = new JSONArray(categories);
    %>

    <script>
        $(function () {
            var autoCategorias = <%=jsonArray%>;
            $("#categoria").autocomplete({
                source: autoCategorias
            });
        });
        $(document).ready(function () {
            $('#add').click(function (event) {
                event.preventDefault();
                var nombreVar = "";
                nombreVar = $('#nombre').val();
                var precioVar = "";
                precioVar = $('#precio').val();
                var catVar = "";
                catVar = $('#categoria').val();
                var actionVar = "add";
                $.post('../restauran3/displaymenu', {
                    nombre: nombreVar,
                    precio: precioVar,
                    categoria: catVar,
                    action: actionVar
                }, function (responseText) {
                    var id = '' + responseText.nombre + '';
                    if (id.valueOf() == "newCat") {
                        location.reload();
                    } else if (id.valueOf() == "vacio") {
                        alert("No pueden quedar casilleros en blanco");
                    }
                    else {
                        $('#' + responseText.categoria + ' tr:last').after('<tr><td><input type=text value="' + responseText.nombre + '"id="' + responseText.nombre + '"></td><td><input type=text value="' + responseText.precio + '"id="' + responseText.precio + '"></td><td><input type=radio name="radio"  value=' + responseText.id + ' ></td></tr>');
                        $('#nombre').val("");
                        $('#precio').val("");
                        $('#categoria').val("");
                    }
                });
            });
            $('#delete').click(function (event) {
                event.preventDefault();
                var selectedVar = $("input[type='radio'][name='radio']:checked").val();
                var actionVar = "delete";
                var statusVar = confirm('¿Realmente desea borrar el articulo seleccionado?');
                $.post('../restauran3/displaymenu', {
                    selected: selectedVar,
                    action: actionVar,
                    status: statusVar
                }, function (responseText) {
                    var id = '' + responseText.id + '';
                    if (id.valueOf() == "no selected") {
                        alert("Debe seleccionar que articulo desea borrar");
                    } else {
                        location.reload();
                    }
                });
            });


            $('#edit').click(function (event) {
                event.preventDefault();
                var selectedVar = $("input[type='radio'][name='radio']:checked").val();
                var actionVar = "edit";
                var $row = $("tr[data-id='" + selectedVar + "']");
                $.post('../restauran3/displaymenu', {
                    selected: selectedVar,
                    action: actionVar,
                    newNombre: $row.find("input[type=text]").val(),
                    newPrecio: $row.find('input[name="precio' + selectedVar + '"]').val()
                },
                        function (responseText) {
                    var id = '' + responseText.id + '';
                    if (id.valueOf() == "no selected") {
                        alert("Debe seleccionar que articulo desea editar");
                    } else if (id.valueOf() == "campo vacio") {
                        alert("No pueden quedar casilleros en blanco");
                    } else {
                        alert("Articulo editado con exito");
                    }
                });
            });
        });

    </script>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

</head>

<jsp:include page="adminHome.jsp"></jsp:include>

<body>

<form id="reg-form" action="../restauran3/displaymenu" method="post">

    <h3 align="center"><span class="label label-primary">Agregar Articulo</span></h3>

    <br>
    <table align="center">
        <tr>
            <td>
                <div class="input-group">
                    <span class="input-group-addon" id="basic-addon1">Nombre</span>
                    <input type="text"class="form-control" id="nombre" name="nombre"
                           spellcheck="false"
                           aria-describedby="basic-addon1">
                </div>
            </td>
            <td>
                <div class="input-group">
                    <span class="input-group-addon" id="basic-addon2">Precio</span>
                    <input type="number" min="1" class="form-control" id="precio" name="precio"
                           spellcheck="false"
                           aria-describedby="basic-addon1">
                </div>
            </td>
            <td>
                <div class="input-group">
                    <span class="input-group-addon" id="basic-addon3">Categoria</span>
                    <input type="text" class="form-control" id="categoria" name="categoria"
                           spellcheck="false"
                           aria-describedby="basic-addon1">
                    <input type="hidden" value="<%=jsonArray%>" id="jsonArray">
                </div>
            </td>
        </tr>


    </table>
    <br>
    <div align="center">
        <div class="btn-group" role="group" aria-label="..." align="center">
            <button type="submit" class="btn btn-default" name="add" id="add">Agregar</button>
        </div>
    </div>

    <%
        JSONArray json = (JSONArray) request.getAttribute("json");
    %>


    <script>

        $(function() {

            $("#jsGrid").jsGrid({
                height: "90%",
                width: "100%",

                inserting: true,
                filtering: false,
                editing: true,
                sorting: true,
                paging: true,
                autoload: true,

                pageSize: 10,
                pageButtonCount: 2,

                deleteConfirm: function(item) {
                    return "The client \"" + item.nombre + "\" will be removed. Are you sure?";
                },

                controller: {
                    loadData: function (filter) {
                    },
                    insertItem: function (item) {
                        if (item.nombre != "" && item.precio != null && item.categoria!= ""){
                        return $.post("../restauran3/displaymenu", {
                            name: item.nombre,
                            price: item.precio,
                            category: item.categoria,
                            action: "add",
                            status: true

                        })
                        }else {
                            alert("campo vacio no se agrego el articulo");
                            $("#jsGrid").jsGrid("clearInsert");
                            location.reload();

                        };
                    },
                    updateItem: function (item) {
                        if (item.nombre != "" && item.precio != null && item.categoria!= ""){
                            return $.post("../restauran3/displaymenu", {
                                name: item.nombre,
                                price: item.precio,
                                category: item.categoria,
                                action: "edit",
                                selected: item.idArticulo

                            })
                        }else{
                            alert("campo vacio no se realizaron los cambios");
                            $("#jsGrid").jsGrid("cancelEdit");
                            location.reload();

                        }
                    },
                    deleteItem: function (item) {
                         return $.post("../restauran3/displaymenu",{
                            id: item.idArticulo,
                            action: "delete",
                            status: true

                        });
                    }
                },

                data: <%=json%>,

                fields: [
                    { name: "nombre", type: "text", width: 50 },
                    { name: "precio", type: "number", width: 20},
                    { name: "categoria", type: "text", width: 50},
                    { type: "control" }
                ]
            });

        });
    </script>

    <script>



    </script>

    <%    for (int i = 0; i <categoriasAuto.size() ; i++) {

    %>
    <div id="jsGrid"></div>
    <%
        }
    %>



</form>

<script src="js/bootstrap.min.js"></script>

</body>
</html>