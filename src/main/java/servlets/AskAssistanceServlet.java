package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;
import tables.Mesa;
import tables.Orden;

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
        Transaction tx = null;

        try{
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            Principal userPrincipal = request.getUserPrincipal();
            String idMesa = userPrincipal.getName();

            Mesa mesa = (Mesa) session.createQuery("from Mesa where id='"+idMesa+ "'").uniqueResult();

            String asistir = "Asistir mesa";
            if (!mesa.getAsistencia().equals(asistir)) {
                tx = session.beginTransaction();
                mesa.setAsistencia(asistir);
                session.saveOrUpdate(mesa);
                tx.commit();
            }

            response.sendRedirect("/restauran3/jsps/secure/user/userHome.jsp");
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

}
