import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/MyServlet")
public class aa extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Your Java function logic goes here
        myJavaFunction();

        // Send a response (if needed)
        response.getWriter().write("Java function executed successfully");
    }

    private void myJavaFunction() {
        // Implement your Java function logic here
        System.out.println("Java function executed");
    }
}