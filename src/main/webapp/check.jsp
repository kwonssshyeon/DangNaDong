<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Validation</title>
    <style>
        .error {
            color: red;
        }
    </style>
</head>
<body>

    <h2>Simple Form Validation</h2>

    <form id="myForm" onsubmit="return validateForm()">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>
        <span id="nameError" class="error"></span>

        <br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
        <span id="emailError" class="error"></span>

        <br>

        <input type="submit" value="Submit">
    </form>

    <script>
        function validateForm() {
            // 이름 필드 검사
            var name = document.getElementById("name").value;
            if (name == "") {
                document.getElementById("nameError").innerHTML = "이름을 입력하세요.";
                return false;
            } else {
                document.getElementById("nameError").innerHTML = "";
            }

            // 이메일 필드 검사
            var email = document.getElementById("email").value;
            if (email == "") {
                document.getElementById("emailError").innerHTML = "이메일을 입력하세요.";
                return false;
            } else {
                document.getElementById("emailError").innerHTML = "";
            }

            // 여기에 추가적인 유효성 검사를 수행할 수 있습니다.

            return true; // 폼이 유효하면 제출
        }
    </script>

</body>
</html>