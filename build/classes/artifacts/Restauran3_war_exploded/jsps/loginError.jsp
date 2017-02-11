<%--
  Created by IntelliJ IDEA.
  User: AlumnosFI
  Date: 30/03/2016
  Time: 12:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="securityfilter.Constants"%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>Login</title>
    <link rel="stylesheet" href="/restauran3/css/animate.css">
    <link rel="stylesheet" href="/restauran3/css/login.css">
</head>
<body>
<br>

<form class="container" id="<%=Constants.LOGIN_FORM_ID%>" action="<%=response.encodeURL(Constants.LOGIN_FORM_ACTION)%>" method="POST">
    <body>
    <div class="container">
        <div class="top">

            <center>
                Error! Username/password incorrecto/s. Por favor, intente nuevamente.<br>
            </center>

            <div id="divimagen">
                <img id="imagen" src="../images/Restauran3-logo.png" alt="Logo">
            </div>

            <h1 id="title" class="hidden"><span id="logo">Restauran3 <span></span></span></h1>
        </div>
        <div class="login-box animated fadeInUp">
            <div class="box-header">
                <h2>Log In</h2>
            </div>
            <label for="username">Username</label>
            <br/>
            <input type="text" name="<%=Constants.LOGIN_USERNAME_FIELD%>"
                   id="username" value="">
            <br/>
            <label for="password">Password</label>
            <br/>
            <input type="password" id="password" name="<%=Constants.LOGIN_PASSWORD_FIELD%>"
                   value="">
            <br/>
            <button type="submit" value="Ingresar">Ingresar</button>
            <button type="Reset" value="Borrar todo">Borrar</button>
            <br/>

        </div>
    </div>
    </body>
</form>

</body>
</html>