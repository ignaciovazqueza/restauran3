package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;
import tables.Mesa;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Created by AlumnosFI on 01/06/2016.
 */
@WebServlet(name = "DisplayAsisstancesServlet", urlPatterns = {"/displayassistances"})
public class DisplayAsisstancesServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Transaction tx = null;
        try {
            String asistido = "No pide asistencia";
            Session session = HibernateUtil.getInstance().getSession();
            String selected = request.getParameter("name");
            if (selected != null) {
                Mesa mesa = (Mesa) session.createQuery("from Mesa where id='" + selected + "'");
                mesa.setAsistencia(asistido);
                tx = session.beginTransaction();
                session.saveOrUpdate(mesa);
                tx.commit();
            }

            String id = "{ \"name\": \"" + selected + "\"}";
            response.setContentType("application/json");
              PrintWriter out = response.getWriter();
              out.print(id);
              out.flush();
        } catch (Exception e) {
            e.printStackTrace();

        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;character=UTF-8");
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        PrintWriter out = response.getWriter();
        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            List<Mesa> mesas = session.createQuery("from Mesa where asistencia='Asistir mesa'").list();
            request.setAttribute("mesas", mesas);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/displayAssistances.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            RequestDispatcher rd = request.getRequestDispatcher("/error.jsp");
            rd.forward(request, response);
        } finally {
            out.close();
        }
    }

}
