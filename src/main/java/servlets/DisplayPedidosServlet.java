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
import java.security.Principal;
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
                String id = request.getParameter("id");
                String mesa = request.getParameter("table");
                String status = "";
                Boolean moreTables = false;
                if (id!=null) {
                        Pedido pedido = (Pedido) session.createQuery("from Pedido where idPedido= " + id + "").uniqueResult();
                        pedido.setEntregado("Entregado");
                        String estado = "A la espera";
                        List<Pedido>  pedidos = session.createQuery("from Pedido where entregado ='" + estado + "'").list();

                    for (Pedido espera:  pedidos) {
                        Orden orden = (Orden) session.createQuery("from Orden where idorden= " + espera.getIdOrden() + "").uniqueResult();
                        if (!(orden.getIdMesa()).equals(mesa)){
                            moreTables = true;
                            break;
                        }
                    }
                        tx = session.beginTransaction();
                        session.saveOrUpdate(pedido);
                        tx.commit();
                        status = "ok";

                }
                String ped = "{ \"status\": \"" + status + "\",\"id\":\""+id+"\",\"mesa\":\""+mesa+"\",\"tables\":\""+moreTables+"\"}";
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(ped);
                out.flush();

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
            Principal userPrincipal = request.getUserPrincipal();
            if (!userPrincipal.getName().equals(RedirectServlet.getAdminName())) {
                RequestDispatcher rd = request.getRequestDispatcher("/error/401.jsp");
                rd.forward(request,response);
            } else {
                List<Mesa> mesas = session.createQuery("from Mesa").list();
                request.setAttribute("mesas", mesas);
                RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/displayPedidos.jsp");
                rd.forward(request, response);
            }
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
            orden = (Orden) session.createQuery("from Orden where idMesa='"+ idMesa + "' and estado='opened'").uniqueResult();
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
            pedidos = session.createQuery("from Pedido where idOrden="+ idOrden + " and entregado = 'A la espera'").list();
        }catch (Exception e){
        }
        finally {
            return pedidos;
        }
    }


}
