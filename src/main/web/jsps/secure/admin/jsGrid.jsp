<%@ page import="tables.Categoria" %>
<%@ page import="java.util.List" %>
<%@ page import="tables.Menu" %>
<%@ page import="securityfilter.Constants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title><%=Constants.COMMON_TITLE_BASE%>Menu</title>

    <% String username = request.getUserPrincipal().getName();%>

    <script>
        function window_onload() {

            $(document).ready(function () {
                var a = $('.link-1')[2];
                a.parentElement.className = 'active';

                $("button[name='eliminarMenu']").click(function (event) {
                    event.preventDefault();
                    var idVar = this.value;
                    var actionVar = "delete";
                    $.post('../restauran3/displaymenu', {id: idVar, action: actionVar}, function (responseText) {
                        var data = '' + responseText.state + '';
                        if (data.valueOf() === "ok") {
                            $('#'+responseText.id).remove();
                        }
                    })
                });

                $("button[name='editarMenu']").click(function (event) {
                    event.preventDefault();
                    var idVar = this.value;
                    var actionVar = "edit";
                    var nameVar = $('#name'+this.value).val();
                    var priceVar = $('#price'+this.value).val()
                    $.post('../restauran3/displaymenu', {id: idVar, action: actionVar, nombre: nameVar, precio: priceVar}, function (responseText) {
                        var data = '' + responseText.state + '';
                        if (data.valueOf() === "ok") {
                            alert("Menu editado");
                        }else{
                            alert("No se pueden dejar campos en blanco");
                            $('#name'+responseText.id).val(responseText.nombre);
                            $('#price'+responseText.id).val(responseText.precio);
                        }
                    })
                });

                $("button[name='upMenu']").click(function (event) {
                    event.preventDefault();
                    var idUp = this.value;

                    var actionVar = "moveUp";
                    $.post('../restauran3/displaymenu', {id: idUp, action: actionVar}, function (responseText) {
                        var data = '' + responseText.status + '';
                        if (data.valueOf() === "ok") {
                            $('#name' + responseText.idUp).val(responseText.nombreDown);
                            $('#name' + responseText.idDown).val(responseText.nombreUp);
                            $('#name' + responseText.idUp)[0].id = "aux";
                            $('#name' + responseText.idDown)[0].id = "name"+responseText.idUp;
                            $('#aux')[0].id = "name"+responseText.idDown;

                            $('#price' + responseText.idUp).val(responseText.precioDown);
                            $('#price' + responseText.idDown).val(responseText.precioUp);
                            $('#price' + responseText.idUp)[0].id = "aux";
                            $('#price' + responseText.idDown)[0].id = "price"+responseText.idUp;
                            $('#aux')[0].id = "price"+responseText.idDown;

                            $('#'+responseText.idUp)[0].children[3].children[0].children[0].value = responseText.idDown;
                            $('#'+responseText.idDown)[0].children[3].children[0].children[0].value = responseText.idUp;
                            $('#'+responseText.idUp)[0].id = responseText.idDown;
                            $('#'+responseText.idDown)[0].id = responseText.idUp;
                        }
                    })
                });

                $("button[name='downMenu']").click(function (event) {
                    event.preventDefault();
                    var idUp = this.value;
                    var actionVar = "moveDown";
                    $.post('../restauran3/displaymenu', {id: idUp, action: actionVar}, function (responseText) {
                       location.reload();
                    })
                });

                $("button[name='saveMenu']").click(function (event) {
                    event.preventDefault();
                    var catVar = this.value;
                    var nombreVar = $('#nombreTd'+catVar.valueOf()).prop('value');
                    var precioVar = $('#precioTd'+catVar.valueOf()).prop('value');
                    var actionVar = "add";
                    $.post('../restauran3/displaymenu', {precio: precioVar,categoria: catVar, nombre: nombreVar, action: actionVar}, function (responseText) {
                        var data = '' + responseText.nombre + '';
                        if (data.valueOf() === "vacio"){
                            alert("no pueden quedar campos vacios, cambiar");
                        }else{
                            $('#menu'+responseText.categoria+' tr:last').after(''
                                    +'<tr class="row" id='+responseText.id+'"> <td class="col s5"> <div> <div class="input-field">'
                                    +'<input value='+responseText.nombre+' id="name'+responseText.id+'" type="text" class="validate"> <label class="active" ></label>'
                                    +'</div> </div> </td> <td class="col s5"> <div> <div class="input-field">'
                                    +'<input value='+responseText.precio+' id="price"'+responseText.id+'" type="text" class="validate"> <label class="active" ></label>'
                                    +'</div> </div> </td> <td class="col s1"> <div class="btn-group" role="group" aria-label="..." align="center">'
                                    +'<button type="submit" class="btn btn-floating small light-blue darken-3" id="editarMenu" name="editarMenu" value='+responseText.id+'" ><i class="material-icons">check</i>'
                                    +'</button> </div> <div class="btn-group" role="group" aria-label="..." align="center">'
                                    +'<button type="submit" class="btn btn-floating small light-blue darken-3" id="eliminarMenu" name="eliminarMenu" value='+responseText.id+'"><i class="material-icons">delete</i>'
                                    +'</button> </div> </td> <td class="col s1"> <div class="btn-group" role="group" aria-label="..." align="center">'
                                    +'<button type="submit" class="btn btn-floating small light-blue darken-3" name="upMenu" id="upMenu" value='+responseText.id+'" ><i class="material-icons">arrow_upward</i>'
                                    +'</button> </div> <div class="btn-group" role="group" aria-label="..." align="center">'
                                    +'<button type="submit" class="btn btn-floating small light-blue darken-3" name="downMenu" id="downMenu" value='+responseText.id+'" ><i class="material-icons">arrow_downward</i>'
                                    +'</button> </div> </td> </tr>');

                            $('#nombreTd'+responseText.categoria).val("");
                            $('#precioTd'+responseText.categoria).val("");
                        }
                    })
                });
            });

        }

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
                        <span class="card-title" style="font-size: 1.5em;">Menu</span>
                    </div>
                </div>
            </div>

            <form id="reg-form" action="../../restauran3/orderitem" method="post">

                <li>
                    <table align="center" class="striped" width="300">
                        <tr class="row">
                            <td class="col s5">Agregar Categoria</td>
                            <td class="col s5">
                                <div>
                                    <div class="input-field">
                                        <input  id="newCat" type="text" class="validate">
                                        <label class="active" ></label>
                                    </div>
                                </div>
                            </td>
                            <td class="col s2">
                                <div class="btn-group" role="group" aria-label="..." align="center">
                                    <button type="submit" class="btn btn-floating small light-blue darken-3" name="addCat" id="addCat"><i class="material-icons">add</i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </table>
                </li>

                <ul class="collapsible" data-collapsible="accordion">
                    <% List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
                        for (Categoria categoria : categorias) {
                    %>

                    <style>
                        #
                        <%=categoria.getNombre()%>
                        ,
                        #table {
                            padding: 5px;
                            text-align: center;
                            background-color: #1b6595;
                            border: solid 1px #c3c3c3;
                            color: white;
                            width: 10%;
                        }
                    </style>


                    <li>
                        <div class="collapsible-header active center-align"
                             style="background-color: #1b6595; color: white;" id=<%=categoria.getNombre()%>>
                            <%=categoria.getNombre()%>
                        </div>
                        <div class="collapsible-body active" id="panel<%=categoria.getNombre()%>"
                             style="padding: 0rem;">
                            <table align="center" class="striped" width="300"
                                   style="overflow-x:auto; text-align: center;" id="menu<%=categoria.getNombre()%>" bgcolor="white">
                                <thead>
                                <tr class="row" id="topRow">
                                    <th class="col s5">Nombre</th>
                                    <th class="col s5">Precio</th>
                                    <th class="col s1"></th>
                                    <th class="col s1"></th>

                                </tr>
                                </thead>
                                <tr class="row" id="addRow">
                                    <td class="col s5">
                                        <div>
                                            <div class="input-field">
                                                <input id="nombreTd<%=categoria.getNombre()%>" type="text" class="validate">
                                                <label class="active"  name="nombreTd"></label>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="col s5">
                                        <div>
                                            <div class="input-field">
                                                <input  id="precioTd<%=categoria.getNombre()%>" type="text" class="validate">
                                                <label class="active"   name="precioTd"></label>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="col s2">
                                        <div class="btn-group" role="group" aria-label="..." align="center">
                                            <button type="submit" class="btn btn-floating small light-blue darken-3" value=<%=categoria.getNombre()%> id="saveMenu" name="saveMenu" ><i class="material-icons">save</i>
                                            </button>
                                        </div>
                                    </td>

                                </tr>
                                <% List<Menu> data = (List<Menu>) request.getAttribute("data");
                                    for (Menu menu : data) {
                                        if (menu.getCategoria().equals(categoria.getNombre())) {
                                            int id = menu.getIdArticulo();
                                            int index = menu.getIndex();
                                %>
                                <tr class="row" id=<%=id%>>

                                    <td class="col s5">
                                        <div>
                                            <div class="input-field">
                                                <input value='<%=menu.getNombre()%>' id="name<%=id%>" type="text" class="validate">
                                                <label class="active" ></label>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="col s5">
                                        <div>
                                            <div class="input-field">
                                                <input value='<%=menu.getPrecio()%>' id="price<%=id%>" type="text" class="validate">
                                                <label class="active" ></label>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="col s1">
                                        <div class="btn-group" role="group" aria-label="..." align="center">
                                            <button type="submit" class="btn btn-floating small light-blue darken-3" id="editarMenu" name="editarMenu" value=<%=id%> ><i class="material-icons">check</i>
                                            </button>
                                        </div>
                                        <div class="btn-group" role="group" aria-label="..." align="center">
                                            <button type="submit" class="btn btn-floating small light-blue darken-3" id="eliminarMenu" name="eliminarMenu" value=<%=id%>><i class="material-icons">delete</i>
                                            </button>
                                        </div>
                                    </td>
                                    <td class="col s1">
                                        <div class="btn-group" role="group" aria-label="..." align="center">
                                            <button type="submit" class="btn btn-floating small light-blue darken-3" name="upMenu" id="upMenu" value=<%=id%> ><i class="material-icons">arrow_upward</i>
                                            </button>
                                        </div>
                                        <div class="btn-group" role="group" aria-label="..." align="center">
                                            <button type="submit" class="btn btn-floating small light-blue darken-3" name="downMenu" id="downMenu" value=<%=id%> ><i class="material-icons">arrow_downward</i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%}%>
                                <%}%>
                            </table>
                        </div>
                    </li>

                    <%}%>
                </ul>

                <br>

            </form>
        </div>
    </div>
</div>
</body>
</html>