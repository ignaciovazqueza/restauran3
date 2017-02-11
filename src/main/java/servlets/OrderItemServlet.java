package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;
import tables.Categoria;
import tables.Menu;
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
import java.util.ArrayList;
import java.util.List;

/**
 * Created by AlumnosFI on 20/04/2016.
 */
@WebServlet(name = "OrderItemServlet", urlPatterns ={"/orderitem"})
public class OrderItemServlet extends HttpServlet {

    List list = new ArrayList();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;
        Transaction tx2 = null;

        try{
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            Principal userPrincipal = request.getUserPrincipal();
            String idMesa = userPrincipal.getName();
            Integer idorden = (Integer) session.createQuery("select idorden from Orden where idMesa='" + idMesa + "' and estado='opened'").uniqueResult();
            if(idorden == null){
                tx= session.beginTransaction();
                Orden orden = new Orden();
                orden.setEstado("opened");
                orden.setIdMesa(idMesa);
                session.saveOrUpdate(orden);
                tx.commit();
                idorden =(Integer) session.createQuery("select idorden from Orden where idMesa='" + idMesa + "' and estado='opened'").uniqueResult();
            }
            int contador=0;
            List<Integer> idArticulos =  session.createQuery("select idArticulo from Menu").list();
            for (int i = 0; i <idArticulos.size() ; i++) {
                String cantidad = request.getParameter(Integer.toString(idArticulos.get(i)));
                if(cantidad != "" && cantidad != "0") {
                    tx2= session.beginTransaction();
                    Pedido pedido = new Pedido();
                    pedido.setCantidad(cantidad);
                    pedido.setEntregado("Pidiendo...");
                    pedido.setIdOrden(idorden);
                    pedido.setIdArticulo(idArticulos.get(i));
                    session.saveOrUpdate(pedido);
                    tx2.commit();
                    contador++;
                }
            }
            if (contador!=0)response.sendRedirect("/restauran3/closepedidos");
            else response.sendRedirect("/restauran3/orderitem");
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;character=UTF-8");
        try {
            Session session = HibernateUtil.getInstance().getSession();
            List<Categoria> categorias = session.createQuery("from Categoria").list();
            List<Menu> data = session.createQuery("from Menu").list();

            request.setAttribute("categorias",categorias);
            request.setAttribute("data",data);

            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/user/orderItem.jsp");
            rd.forward(request,response);
        }catch (Exception e){
            RequestDispatcher rd = request.getRequestDispatcher("/error.jsp");
            rd.forward(request,response);
        }
        finally {
            list.clear();
        }
    }
}
