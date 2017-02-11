package servlets;

import securityfilter.AdminValues;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by AlumnosFI on 04/05/2016.
 */
@WebServlet(name = "EditAdminServlet" , urlPatterns = {"/editAdmin"})
public class EditAdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String actual = request.getParameter("passworda");
        String nueva = request.getParameter("password");
        String confirmada = request.getParameter("passwordc");
        AdminValues admin = new AdminValues();
        try {
            if (!actual.equals(admin.getPassword())) {
                //show alert de password actual incorrecta
            } else {
                if (nueva != "" && nueva != null) {
                    if (nueva.equals(confirmada)) {
                        admin.setPassword(nueva);
                    } else{
                        //mandar alert de password distintas
                    }
                } else if (nombre != "" && nombre != null){
                    admin.setUser(nombre);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("/restauran3/editAdmin");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        AdminValues adminValues = new AdminValues();
        request.setAttribute("username", adminValues.getUser());
        request.setAttribute("pass",adminValues.getPassword());
        RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/editAdminUser.jsp");
        rd.forward(request, response);

    }
}
