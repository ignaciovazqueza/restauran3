<%@ page import="securityfilter.Constants" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>Error</title>
    <link rel="stylesheet" href="/restauran3/css/animate.css">
    <link rel="stylesheet" href="/restauran3/css/login.css">
    <script type="text/javascript" src="/restauran3/materialize/js/materialize.min.js"></script>
    <link rel="stylesheet" href="/restauran3/materialize/css/materialize.min.css">
</head>
<body>

<form class="container">
    <body>
    <div class="container" align="center">
        <div class="top">

            <div id="divimagen">
                <img id="imagen" src="/restauran3/images/Restauran3-logo.png" alt="Logo">
            </div>

            <h1 id="title" class="hidden"><span id="logo">Restauran3 <span></span></span></h1>
        </div>
        <br>
        <br>
        <div class="row" align="center">
            <div class="col s12 m6 offset-m3" align="center" >
                <div class="card-panel" align="center">
                    <span class="black-text">El servicio al que intenta acceder no esta disponible para su rol.</span>
                    <div class="btn-group" role="group" aria-label="..." align="center" id="volverButton">
                        <br>
                        <a href="javascript:history.back()" class="btn btn-default light-blue darken-3" name="volver" id="volver">Volver
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </body>
</form>

</body>
</html>