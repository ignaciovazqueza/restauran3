package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONObject;
import securityfilter.util.HibernateUtil;
import tables.Categoria;
import tables.Menu;
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
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Tomas on 4/20/2016.
 */
@WebServlet(name = "DisplayTablesServlet", urlPatterns ={"/displaytables"})
public class DisplayTablesServlet extends HttpServlet {

    List list = new ArrayList();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;character=UTF-8");
        try {
            Session session = HibernateUtil.getInstance().getSession();
            List<Mesa> data = session.createQuery("from Mesa").list();
            request.setAttribute("data", data);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/displayTables.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            RequestDispatcher rd = request.getRequestDispatcher("/error.jsp");
            rd.forward(request, response);
        } finally {
            list.clear();
        }


    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String post = request.getParameter("action");
        switch (post){
            case("add"): agregarMesa(request,response);
                break;
            case("delete"): borrarMesa(request,response);
                break;
            case("edit"): editMesa(request,response);
                break;

        }

    }

    private void borrarMesa(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;
        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            String selected = request.getParameter("selected");
            String status = request.getParameter("status");
            String idMesa;
            String token="";

            if (selected!=null && status.equals("true")) {
                Mesa mesa = (Mesa) session.createQuery("from Mesa where mesa='" + selected + "'").uniqueResult();
                idMesa = mesa.getMesa();
                token = mesa.getToken();
                String table = "{ \"id\": \"" + idMesa + "\", \"token\": \"" + token + "\" }";
                tx = session.beginTransaction();
                session.delete(mesa);
                tx.commit();

                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(table);
                out.flush();
            }else if (selected==null && status.equals("true")){
                idMesa = "no selected";
                String table = "{ \"id\": \"" + idMesa + "\", \"token\": \"" + token + "\" }";
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(table);
                out.flush();
            }

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private void agregarMesa(HttpServletRequest request, HttpServletResponse response) {

        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        try {
            String idMesa = request.getParameter("mesa");
            String token = request.getParameter("token");

            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            if (!idMesa.equals("") && !token.equals("")) {
                tx = session.beginTransaction();
                Mesa mesa = new Mesa();
                mesa.setMesa(idMesa);
                mesa.setToken(token);
                mesa.setAsistencia("No pide asistencia");
                Mesa newMesa = (Mesa) session.createQuery("from Mesa where mesa ='" + idMesa + "'").uniqueResult();

                if (newMesa == null) {
                    session.saveOrUpdate(mesa);
                    tx.commit();

                    String table = "{ \"id\": \"" + idMesa + "\", \"token\": \"" + token + "\" }";
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print(table);
                    out.flush();
                } else {
                    token = "mesa duplicada";
                    String table = "{ \"id\": \"" + idMesa + "\", \"token\": \"" + token + "\" }";
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print(table);
                    out.flush();
                }
            }else{
                token = "dato vacio";
                String table = "{ \"id\": \"" + idMesa + "\", \"token\": \"" + token + "\" }";
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(table);
                out.flush();
            }
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void editMesa(HttpServletRequest request, HttpServletResponse response) {
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;
        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            String selected = request.getParameter("selected");
            if (selected!=null) {
                Mesa mesa = (Mesa) session.createQuery("from Mesa where mesa= '" + selected + "' ").uniqueResult();
                String token = request.getParameter("newToken");
                String idMesa = mesa.getMesa();
                if (token != "" && !token.equals(null)) {
                    mesa.setToken(token);
                }
                String table = "{ \"id\": \"" + idMesa + "\", \"token\": \"" + token + "\" }";
                tx = session.beginTransaction();
                session.saveOrUpdate(mesa);
                tx.commit();

                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(table);
                out.flush();
            } else {
                String idMesa = "no selected";
                String table = "{ \"id\": \"" + idMesa + "\"}";
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(table);
                out.flush();
            }

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}