package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;
import tables.Mesa;
import tables.Orden;
import tables.Pedido;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;
import java.util.List;

/**
 * Created by AlumnosFI on 18/05/2016.
 */
@WebServlet(name = "CloseTableServlet", urlPatterns ={"/closetable"})
public class CloseTableServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;
        Transaction tx2 = null;
        Transaction tx3 = null;

        try{
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            Principal userPrincipal = request.getUserPrincipal();
            String idMesa = userPrincipal.getName();
            Orden orden = (Orden) session.createQuery("from Orden where idMesa='" + idMesa + "' and estado='opened'").uniqueResult();
            int idorden = orden.getIdorden();

            List<Pedido> pidiendo = session.createQuery("from Pedido where idOrden=" + idorden + " and entregado='Pidiendo...'").list();
            for(Pedido pedido: pidiendo){
                tx2= session.beginTransaction();
                session.delete(pedido);
                tx2.commit();
            }

            List<Pedido> alaespera = session.createQuery("from Pedido where idOrden=" + idorden + " and entregado='A la espera'").list();
            for(Pedido pedido: alaespera){
                tx3= session.beginTransaction();
                pedido.setEntregado("Entregado");
                session.saveOrUpdate(pedido);
                tx3.commit();
            }

            Mesa mesa = (Mesa) session.createQuery("from Mesa where mesa='" + idMesa + "'").uniqueResult();


            tx= session.beginTransaction();
            orden.setEstado("closed");
            mesa.setAsistencia("No pide asistencia");
            session.saveOrUpdate(orden);
            session.saveOrUpdate(mesa);
            tx.commit();

            response.sendRedirect("/restauran3/logout");
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String driver = "org.hsqldb.jdbc.JDBCDriver";

        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            Principal userPrincipal = request.getUserPrincipal();
            String idMesa = userPrincipal.getName();
            Integer idorden = (Integer) session.createQuery("select idorden from Orden where idMesa='" + idMesa + "' and estado='opened'").uniqueResult();
            List<Pedido> alaespera = session.createQuery("from Pedido where idOrden=" + idorden + " and entregado='A la espera'").list();
            List<Pedido> entregados = session.createQuery("from Pedido where idOrden=" + idorden + " and entregado='Entregado'").list();

            request.setAttribute("entregados",entregados);
            request.setAttribute("alaespera",alaespera);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/user/closeTable.jsp");
            rd.forward(request,response);

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
