package servlets;

import securityfilter.AdminValues;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;

/**
 * Created by AlumnosFI on 13/04/2016.
 */
public class RedirectServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Principal userPrincipal = request.getUserPrincipal();

        String name = userPrincipal.getName();

        if(name.equals(getAdminName())) {
            response.sendRedirect("/restauran3/displaypedidos");
        } else {
            response.sendRedirect("/restauran3/orderitem");
        }
    }

    private String getAdminName() throws IOException {

        AdminValues adminValues = new AdminValues();
        String name ="";
        try {
            name = adminValues.getAdminName();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return name;
    }
}
