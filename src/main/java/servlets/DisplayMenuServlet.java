package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.securityfilter.realm.catalina.CatalinaRealmAdapter;
import securityfilter.util.HibernateUtil;
import tables.Categoria;
import tables.Menu;
import tables.Mesa;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Tomas on 4/7/2016.
 */
@WebServlet(name = "DisplayMenuServlet", urlPatterns ={"/displaymenu"})
public class DisplayMenuServlet extends javax.servlet.http.HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;character=UTF-8");
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        PrintWriter out = response.getWriter();
        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            List<Menu> data = session.createQuery("from Menu").list();
            request.setAttribute("data",data);
            List<Categoria> categorias = session.createQuery("from Categoria ").list();
            request.setAttribute("categorias",categorias);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/displayMenu.jsp");
            rd.forward(request,response);
        }catch (Exception e){
            RequestDispatcher rd = request.getRequestDispatcher("/error.jsp");
            rd.forward(request,response);
        }
        finally {
            out.close();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String post = request.getParameter("action");
        switch (post){
            case("add"): agregarMenu(request,response);
                break;
            case("delete"): borrarMenu(request,response);
                break;
            case("edit"): editMenu(request,response);
                break;

        }

    }

    private void editMenu(HttpServletRequest request, HttpServletResponse response) {
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

            try {
                Class.forName(driver).newInstance();
                Session session = HibernateUtil.getInstance().getSession();
                String selected = request.getParameter("selected");
                if (selected!=null) {
                        Menu menu = (Menu) session.createQuery("from Menu where idArticulo= " + selected + " ").uniqueResult();
                        String nombre = request.getParameter("newNombre");
                        String precio = request.getParameter("newPrecio");

                        if (nombre == "" || precio == ""){
                            nombre = "campo vacio";
                            String art = "{ \"id\": \"" + nombre + "\"}";
                            response.setContentType("application/json");
                            PrintWriter out = response.getWriter();
                            out.print(art);
                            out.flush();
                        } else {
                            menu.setNombre(nombre);
                            menu.setPrecio(Integer.parseInt(precio));

                            String art = "{ \"id\": \"" + nombre + "\", \"precio\": \"" + precio + "\" }";
                            tx = session.beginTransaction();
                            session.saveOrUpdate(menu);
                            tx.commit();

                            response.setContentType("application/json");
                            PrintWriter out = response.getWriter();
                            out.print(art);
                            out.flush();
                        }

                } else {
                    String nombre = "no selected";
                    String art = "{ \"id\": \"" + nombre + "\"}";
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

    private void borrarMenu(HttpServletRequest request, HttpServletResponse response) {

        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

            try {
                Class.forName(driver).newInstance();
                Session session = HibernateUtil.getInstance().getSession();
                String selected = request.getParameter("selected");
                String status = request.getParameter("status");
                String categoriaT = "";
                int precio = 0;
                String nombre = "";
                if (selected!=null && status.equals("true")) {

                    Menu menu = (Menu) session.createQuery("from Menu where idArticulo= " + selected + " ").uniqueResult();
                    String cat = menu.getCategoria();
                    if (selected != null ) {
                        tx = session.beginTransaction();
                        session.delete(menu);
                        tx.commit();

                        List<Menu> menus = (List<Menu>) session.createQuery("from Menu where categoria= '" + cat + "' ").list();
                        System.out.println(menus.isEmpty());
                        if (menus.isEmpty()) {
                            Transaction tx2 = session.beginTransaction();
                            Categoria categoria = (Categoria) session.createQuery("from Categoria where nombre= '" + cat + "' ").uniqueResult();
                            session.delete(categoria);
                            tx2.commit();
                        }
                        nombre = menu.getNombre();
                        categoriaT = menu.getCategoria();
                        precio = menu.getPrecio();

                        String newMenu = "{ \"id\": \"" + nombre + "\",\"categoria\": \"" + categoriaT + "\", \"precio\": \"" + precio + "\"}";
                        response.setContentType("application/json");
                        PrintWriter out = response.getWriter();
                        out.print(newMenu);
                        out.flush();
                    }} else if (selected==null && status.equals("true")){
                        nombre= "no selected";
                        String newMenu = "{ \"id\": \"" + nombre + "\",\"categoria\": \"" + categoriaT + "\", \"precio\": \"" + precio + "\"}";
                        response.setContentType("application/json");
                        PrintWriter out = response.getWriter();
                        out.print(newMenu);
                        out.flush();
                    }

                } catch (IllegalAccessException e1) {
                e1.printStackTrace();
            } catch (InstantiationException e1) {
                e1.printStackTrace();
            } catch (ClassNotFoundException e1) {
                e1.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }

    }




    private void agregarMenu(HttpServletRequest request, HttpServletResponse response) {

        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            String nombre = request.getParameter("nombre");
            String pre = request.getParameter("precio");
            String categoria = request.getParameter("categoria").toUpperCase();
            if (nombre == null || nombre == "" || pre == null || pre == "" || categoria == null ||  categoria == ""){
                nombre = "vacio";
                String newMenu = "{ \"nombre\": \"" + nombre +"\"}";
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(newMenu);
                out.flush();

            }
            else {
                int precio = Integer.parseInt(pre);
                boolean newCat = false;


                String categoriaT = (String) session.createQuery("select nombre from Categoria where nombre='" + categoria + "'").uniqueResult();
                if (categoriaT == null) {
                    tx = session.beginTransaction();
                    Categoria c = new Categoria();
                    c.setNombre(categoria);
                    session.saveOrUpdate(c);
                    tx.commit();
                    categoriaT = categoria;
                    newCat = true;
                }


                tx = session.beginTransaction();
                Menu menu = new Menu();
                menu.setCategoria(categoriaT);
                menu.setNombre(nombre);
                menu.setPrecio(precio);
                session.saveOrUpdate(menu);
                tx.commit();
                int id = menu.getIdArticulo();
                if (newCat) {
                    nombre = "newCat";
                }

                String newMenu = "{ \"nombre\": \"" + nombre + "\",\"categoria\": \"" + categoriaT + "\", \"precio\": \"" + precio + "\",\"id\": \"" + id + "\"}";
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(newMenu);
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

