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
import java.security.Principal;

/**
 * Created by AlumnosFI on 18/05/2016.
 */
@WebServlet(name = "AskAssistanceServlet", urlPatterns ={"/askassistance"})
public class AskAssistanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String driver = "org.hsqldb.jdbc.JDBCDriver";

        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            Principal userPrincipal = request.getUserPrincipal();
            String idMesa = userPrincipal.getName();
            Mesa mesa = (Mesa) session.createQuery("from Mesa where id='" + idMesa + "'").uniqueResult();
            String estado = mesa.getAsistencia();
            request.setAttribute("estado",estado);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/user/asistencia.jsp");
            rd.forward(request,response);

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            Principal userPrincipal = req.getUserPrincipal();
            String idMesa = userPrincipal.getName();

            Mesa mesa = (Mesa) session.createQuery("from Mesa where id='" + idMesa + "'").uniqueResult();

            String asistir = "Asistir mesa";
            if (!mesa.getAsistencia().equals(asistir)) {
                tx = session.beginTransaction();
                mesa.setAsistencia(asistir);
                session.saveOrUpdate(mesa);
                tx.commit();
            }

            resp.sendRedirect("/restauran3/askassistance");

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

    }
}
