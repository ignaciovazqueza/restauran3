package servlets;

import com.sun.org.apache.xpath.internal.operations.Or;
import org.hibernate.Session;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;
import tables.Mesa;
import tables.Orden;

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
@WebServlet(name = "DisplayAsisstancesServlet", urlPatterns ={"/displayassistances"})
public class DisplayAsisstancesServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Transaction tx =null;
        try {
            String asistido = "No pide asistencia";
            Session session = HibernateUtil.getInstance().getSession();
            String[] selected = request.getParameterValues("check");
            if (selected!=null) {
                for (int i = 0; i < selected.length; i++) {
                    List<Mesa> mesas = (List<Mesa>) session.createQuery("from Mesa where id= '" + selected[i] + "'").list();
                    for (Mesa mesa: mesas){
                        if (!mesa.getAsistencia().equals(asistido)) {
                            mesa.setAsistencia(asistido);
                            tx = session.beginTransaction();
                            session.saveOrUpdate(mesa);
                            tx.commit();
                        }
                    }
                }
            }
            response.sendRedirect("/restauran3/displayassistances");
        } catch (Exception e){
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
            request.setAttribute("mesas",mesas);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/displayAssistances.jsp");
            rd.forward(request,response);
        }catch (Exception e){
            RequestDispatcher rd = request.getRequestDispatcher("/error.jsp");
            rd.forward(request,response);
        }
        finally {
            out.close();
        }
    }

}
