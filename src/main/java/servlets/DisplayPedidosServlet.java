package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;
import tables.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Tomas on 5/10/2016.
 */
@WebServlet(name = "DisplayPedidosServlet" ,urlPatterns = {"/displaypedidos"})
public class DisplayPedidosServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Transaction tx =null;

            try {

                Session session = HibernateUtil.getInstance().getSession();
                //String[] selected = request.getParameterValues("check");
                String id = request.getParameter("id");
                if (id!=null) {
                        Pedido pedido = (Pedido) session.createQuery("from Pedido where idPedido= " + id + "").uniqueResult();
                        pedido.setEntregado("Entregado");

                        tx = session.beginTransaction();
                        session.saveOrUpdate(pedido);
                        tx.commit();
                }
                response.sendRedirect("/restauran3/displaypedidos");
            }catch (Exception e){
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
            List<Mesa> mesas = session.createQuery("from Mesa").list();
            request.setAttribute("mesas",mesas);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/displayPedidos.jsp");
            rd.forward(request,response);
        }catch (Exception e){
            RequestDispatcher rd = request.getRequestDispatcher("/error.jsp");
            rd.forward(request,response);
        }
        finally {
            out.close();
        }
    }

    public static Orden getOrden(String idMesa){
        Orden orden = null;
        try {
            Session session = HibernateUtil.getInstance().getSession();
            orden = (Orden) session.createQuery("from Orden where estado='opened' and idMesa='"+ idMesa + "'").uniqueResult();
        }catch (Exception e){
        }
        finally {
            return orden;
        }
    }

    public static List<Pedido> getPedidos(int idOrden){
        List<Pedido> pedidos = new ArrayList<>();
        try {
            Session session = HibernateUtil.getInstance().getSession();
            pedidos = session.createQuery("from Pedido where idOrden="+ idOrden + " and entregado != 'Pidiendo...'").list();
        }catch (Exception e){
        }
        finally {
            return pedidos;
        }
    }


}
