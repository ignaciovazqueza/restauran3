package servlets;

import securityfilter.AdminValues;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "EditAdminServlet" , urlPatterns = {"/editAdmin"})
public class EditAdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getParameter("add") != null) {
            editPassword(request,response);
        } else if (request.getParameter("user") != null) {
            editUser(request,response);
        }
    }

    private void editUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("nombre");
        AdminValues admin = new AdminValues();
        if (user != "" && user != null){
            try {
                admin.setUser(user);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("/restauran3/editAdmin");
    }

    private void editPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String actual = request.getParameter("passworda");
        String nueva = request.getParameter("password");
        String confirmada = request.getParameter("passwordc");
        AdminValues admin = new AdminValues();
        try {
            if (!actual.equals(admin.getPassword())) {
                //show alert de password actual incorrecta
            } else {
                if (!nueva.equals("") && nueva != null) {
                    if (nueva.equals(confirmada)) {
                        admin.setPassword(nueva);
                    } else{
                        //mandar alert de password distintas
                    }
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
