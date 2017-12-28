package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;
import securityfilter.util.HibernateUtil;
import tables.Menu;
import tables.Pedido;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.Principal;
import java.util.List;

/**
 * Created by AlumnosFI on 11/05/2016.
 */
@WebServlet(name = "ClosePedidosServlet" ,urlPatterns = {"/closepedidos"})
public class ClosePedidosServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;
        PrintWriter out = response.getWriter();
        if (request.getParameter("cerrar")!=null){

            try{
                Class.forName(driver).newInstance();
                Session session = HibernateUtil.getInstance().getSession();
                Principal userPrincipal = request.getUserPrincipal();
                String idMesa = userPrincipal.getName();
                Integer idorden = (Integer) session.createQuery("select idorden from Orden where idMesa='" + idMesa + "' and estado='opened'").uniqueResult();

                List<Pedido> pedidos = session.createQuery("from Pedido where idOrden=" + idorden + " and entregado='Pidiendo...' ").list();
                    tx = session.beginTransaction();
                    for (Pedido pedido : pedidos){
                        pedido.setEntregado("A la espera");
                        session.saveOrUpdate(pedido);
                        tx.commit();
                        }

                response.sendRedirect("/restauran3/closepedidos");
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        } else if (request.getParameter("eliminar")!=null){

            try{
                Session session = HibernateUtil.getInstance().getSession();
                String idPedido = request.getParameter("eliminar");
                if (idPedido !=null) {
                        Pedido pedido = (Pedido) session.createQuery("from Pedido where idPedido= " + idPedido + "").uniqueResult();
                        tx = session.beginTransaction();
                        session.delete(pedido);
                        tx.commit();
                    response.sendRedirect("/restauran3/closepedidos");
                }else{
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Debe selecionar lo que quiere borrar');");
                    out.println("location='closepedidos';");
                    out.println("</script>");
                }

            } catch (Exception e){
                e.printStackTrace();
            }
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
            List<Pedido> pedidos = session.createQuery("from Pedido where idOrden=" + idorden + " and entregado='Pidiendo...'").list();
            List<Pedido> alaespera = session.createQuery("from Pedido where idOrden=" + idorden + " and entregado='A la espera'").list();
            List<Pedido> entregados = session.createQuery("from Pedido where idOrden=" + idorden + " and entregado='Entregado'").list();

            request.setAttribute("pedidos",pedidos);
            request.setAttribute("alaespera",alaespera);
            request.setAttribute("entregados",entregados);
            JSONArray jsonE = new JSONArray(entregados);
            request.setAttribute("entregadosJson", jsonE);
            JSONArray jsonP = new JSONArray(pedidos);
            request.setAttribute("pedidosJson", jsonP);
            JSONArray jsonA = new JSONArray(alaespera);
            request.setAttribute("alaesperaJson", jsonA);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/user/closePedidos.jsp");
            rd.forward(request,response);

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Menu getArticulo(int idArticulo){
        Menu menu = null;
        try {
            Session session = HibernateUtil.getInstance().getSession();
            menu = (Menu) session.createQuery("from Menu where idArticulo="+ idArticulo + "").uniqueResult();
        }catch (Exception e){
        }
        finally {
            return menu;
        }
    }
}
