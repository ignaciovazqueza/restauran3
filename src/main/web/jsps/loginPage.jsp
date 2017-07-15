<%@ page import="securityfilter.Constants"%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%=Constants.COMMON_TITLE_BASE%>Login</title>
    <link rel="stylesheet" href="/restauran3/css/animate.css">
    <link rel="stylesheet" href="/restauran3/css/login.css">
</head>
<body>

<form class="container" id="<%=Constants.LOGIN_FORM_ID%>" action="<%=response.encodeURL(Constants.LOGIN_FORM_ACTION)%>" method="POST">
<body>
<div class="container">
    <div class="top">

        <div id="divimagen">
            <img id="imagen" src="/restauran3/images/Restauran3-logo.png" alt="Logo">
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
        <button type="submit" value="Ingresar">Ingresar</button>
        <button type="Reset" value="Borrar todo">Borrar</button>
        <br/>

    </div>
</div>
</body>
</form>

</body>
</html>