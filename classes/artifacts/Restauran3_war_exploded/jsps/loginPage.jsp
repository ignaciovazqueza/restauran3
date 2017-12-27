<%@ page import="securityfilter.Constants"%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>Login</title>
    <link rel="stylesheet" href="/restauran3/css/animate.css">
    <link rel="stylesheet" href="/restauran3/css/login.css">
    <link rel="stylesheet" href="/restauran3/css/jquery-ui.css">
    <link rel="shortcut icon" href="/restauran3/images/Restauran3-logo.png" />

    <script src="/restauran3/js/util/jquery-3.2.1.js"></script>
    <script src="/restauran3/js/util/jquery-ui.js"></script>
    <script type="text/javascript" src="/restauran3/materialize/js/materialize.min.js"></script>
    <link rel="stylesheet" href="/restauran3/materialize/css/materialize.min.css">
</head>

<form class="container" id="<%=Constants.LOGIN_FORM_ID%>" action="<%=response.encodeURL(Constants.LOGIN_FORM_ACTION)%>" method="POST">
<body>
<main>
    <center>
            <div class="top">
                <div id="divimagen">
                    <img id="imagen" src="/restauran3/images/Restauran3-logo.png" alt="Logo">
                </div>
                <h1 id="title" class="hidden"><span id="logo">Restauran3 <span></span></span></h1>
            </div>
            <p></p>
            <div class="z-depth-1 grey lighten-4 row login-box" style="display: inline-block; padding: 32px 48px 0px 48px; border: 1px solid #EEE;">

                    <div class='row'>
                        <div class='input-field col s12'>
                            <input class='validate' type='text' name='<%=Constants.LOGIN_USERNAME_FIELD%>' id='username' />
                            <label for='username'>Usuario</label>
                        </div>
                    </div>

                    <div class='row'>
                        <div class='input-field col s12'>
                            <input class='validate' type='password' name='<%=Constants.LOGIN_PASSWORD_FIELD%>' id='password' value=""/>
                            <label for='password'>Password</label>
                        </div>
                    </div>

                    <center>
                        <div class='row'>
                            <button type='submit' name='btn_login' class='col s12 btn btn-large waves-effect light-blue darken-3'>Ingresar</button>
                        </div>
                        <div class='row'>
                            <button type="Reset" name='btn_reset' class='col s12 btn btn-large waves-effect light-blue darken-3' value="Borrar todo">Borrar</button>
                        </div>
                    </center>
            </div>
    </center>
</main>
</body>
</form>

</html>