<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Button Click Example</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
</head>
<body>

<h1>Click the button to invoke the Java function</h1>

<button id="myButton">Click me</button>

<script>
$(document).ready(function() {
    // Click event for the button
    $("#myButton").on("click", function() {
        // AJAX request to call the Java function
        $.ajax({
            type: "POST",
            url: "MyServlet", // Replace with the actual servlet URL
            success: function(response) {
                // Handle the response from the server (if needed)
                console.log("Java function executed successfully:", response);
                alert(response);
            },
            error: function(error) {
                console.log("Error:", error);
            }
        });
    });
});
</script>

</body>
</html>