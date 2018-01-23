package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;
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
import java.security.Principal;
import java.util.ArrayList;
import java.util.Comparator;
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
            Principal userPrincipal = request.getUserPrincipal();
            if (!userPrincipal.getName().equals(RedirectServlet.getAdminName())) {
                RequestDispatcher rd = request.getRequestDispatcher("/error/401.jsp");
                rd.forward(request,response);
            } else {
                List<Mesa> data = session.createQuery("from Mesa").list();
                request.setAttribute("data", data);

                JSONArray jsonArray = new JSONArray(data);
                request.setAttribute("json", jsonArray);
                RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/displayTables.jsp");
                rd.forward(request, response);
            }
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
            String id = request.getParameter("id");
            String token="";
            String state = "";

            if (id!=null && id!="") {
                Mesa mesa = (Mesa) session.createQuery("from Mesa where mesa='" + id + "'").uniqueResult();
                id = mesa.getMesa();
                token = mesa.getToken();
                tx = session.beginTransaction();
                session.delete(mesa);
                tx.commit();
                state = "ok";
                String table = "{ \"id\": \"" + id + "\", \"token\": \"" + token + "\", \"state\": \"" + state + "\"}";

                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(table);
                out.flush();
            }else {
                state = "no selected";
                String table = "{ \"id\": \"" + id + "\", \"state\": \"" + state + "\" }";
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
            String token = request.getParameter("password");
            String status = "";
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            if (!token.equals(null) && !token.equals("")) {
                tx = session.beginTransaction();
                Mesa mesa = new Mesa();
                mesa.setToken(token);
                mesa.setAsistencia("No pide asistencia");
                List<Mesa> mesas = session.createQuery("from Mesa").list();
                mesas.sort(Comparator.comparing(Mesa::getMesa));
                String lastTable = mesas.get(mesas.size() - 1).getMesa();
                String idMesa = "mesa"+(Integer.parseInt(lastTable.substring(4,5))+1);
                mesa.setMesa(idMesa);
                Mesa newMesa = (Mesa) session.createQuery("from Mesa where mesa ='" + idMesa + "'").uniqueResult();

                if (newMesa == null) {
                    session.saveOrUpdate(mesa);
                    tx.commit();
                    status = "ok";
                    String table = "{ \"id\": \"" + idMesa + "\", \"token\": \"" + token + "\", \"status\": \"" + status + "\" }";
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print(table);
                    out.flush();
                } else {
                    status = "mesa duplicada";
                    String table = "{ \"id\": \"" + idMesa + "\", \"token\": \"" + token + "\", \"status\": \"" + status + "\" }";
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print(table);
                    out.flush();
                }
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
            String id = request.getParameter("id");
            String status = "no selected";
            if (id!=null) {
                Mesa mesa = (Mesa) session.createQuery("from Mesa where mesa='" + id + "'").uniqueResult();
                String token = request.getParameter("token");
                String state = "";
                if (token != null && token != "") {
                    mesa.setToken(token);
                    tx = session.beginTransaction();
                    session.saveOrUpdate(mesa);
                    tx.commit();
                    state = "ok";
                } else{
                    token = ""+mesa.getToken();
                }
                String art = "{ \"state\": \"" + state + "\", \"token\": \"" + token + "\",\"id\":\""+id+"\" }";
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(art);
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