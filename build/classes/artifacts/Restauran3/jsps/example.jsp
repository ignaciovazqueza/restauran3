<%--
  Created by IntelliJ IDEA.
  User: amanda
  Date: 26/06/2017
  Time: 09:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Example</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/zxcvbn/1.0/zxcvbn-async.min.js"></script>
    <link rel="stylesheet" src="../css/example.css"/>

    <script>
        $( document ).ready(function() {
            $('#password').on('propertychange change keyup paste input', function() {
                // TODO: only use the first 128 characters to stop this from blocking the browser if a giant password is entered
                var password = $(this).val();
                var passwordScore = zxcvbn(password)['score'];

                var updateMeter = function(width, background, text) {
                    $('.password-background').css({"width": width, "background-color": background});
                    $('.strength').text('Strength: ' + text).css('color', background);
                }

                if (passwordScore === 0) {
                    if (password.length === 0) {
                        updateMeter("0%", "#ffa0a0", "none");
                    } else {
                        updateMeter("20%", "#ffa0a0", "very weak");
                    }
                }
                if (passwordScore == 1) updateMeter("40%", "#ffb78c", "weak");
                if (passwordScore == 2) updateMeter("60%", "#ffec8b", "medium");
                if (passwordScore == 3) updateMeter("80%", "#c3ff88", "strong");
                if (passwordScore == 4) updateMeter("100%", "#ACE872", "very strong"); // Color needs changing

            });

            // TODO: add ie 8/7 support, what browsers didnt support this check market share
            $('.show-password').click(function(event) {
                event.preventDefault();
                if ($('#password').attr('type') === 'password') {
                    $('#password').attr('type', 'text');
                    $('.show-password').text('Hide password');
                } else {
                    $('#password').attr('type', 'password');
                    $('.show-password').text('Show password');
                }
            });

        });
    </script>

</head>
<body>
<div class="container">
    <div class="row">

        <form>
            <div class="form-group">
                <label for="exampleInputEmail1">Email address</label>
                <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Enter email">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" placeholder="Password">
                <div class="password-background"></div>
                <a class="show-password" href="">Show password</a>
                <span class="strength"></span>
            </div>
        </form>

    </div>
</div>
</body>
</html>
