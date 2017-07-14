package servlets;

import securityfilter.AdminValues;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

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
        String user = request.getParameter("name");
        AdminValues admin = new AdminValues();
        String msg;
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        if (user != "" && user != null){
            try {
                admin.setUser(user);
                msg = "ok";
                String pass = "{ \"msg\": \"" + msg + "\"}";
                out.print(pass);
                out.flush();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void editPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String actual = request.getParameter("passworda");
        String nueva = request.getParameter("password");
        String confirmada = request.getParameter("passwordc");
        AdminValues admin = new AdminValues();
        String msg;
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        try {
            if (!actual.equals(admin.getPassword())) {
                msg = "different";
                String pass = "{ \"msg\": \"" + msg + "\"}";
                out.print(pass);
                out.flush();
            } else {
                if (!nueva.equals("") && nueva != null) {
                    if (nueva.equals(confirmada)) {
                        admin.setPassword(nueva);
                        msg = "ok";
                        String pass = "{ \"msg\": \"" + msg + "\"}";
                        out.print(pass);
                        out.flush();
                    }
                } else {
                    msg = "missing";
                    String pass = "{ \"msg\": \"" + msg + "\"}";
                    out.print(pass);
                    out.flush();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        AdminValues adminValues = new AdminValues();
        request.setAttribute("username", adminValues.getUser());
        request.setAttribute("pass",adminValues.getPassword());
        RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/editAdminUser.jsp");
        rd.forward(request, response);

    }
}
