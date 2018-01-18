package servlets;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;
import securityfilter.util.HibernateUtil;
import tables.Categoria;
import tables.Menu;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Comparator;
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
            data.sort(Comparator.comparing(Menu::getIndex));

            JSONArray jsonArray = new JSONArray(data);
            request.setAttribute("json", jsonArray);
            request.setAttribute("data",data);

            List categoriasNames = new ArrayList();
            List categorias = session.createQuery("from Categoria ").list();
            for (Object c: categorias){
                String categoria = ((Categoria) c).getNombre().toString();
                categoriasNames.add(categoria);
                JSONArray catJson = new JSONArray(session.createQuery("from Menu where categoria ='"+categoria+"'").list());
                request.setAttribute(categoria,catJson);

            }

            request.setAttribute("categorias",categorias);
            request.setAttribute("categoriasNames",categoriasNames);
            RequestDispatcher rd = request.getRequestDispatcher("/jsps/secure/admin/jsGrid.jsp");
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
            case("moveUp"): moveSelectedUp(request,response);
                break;
            case("moveDown"): moveSelectedDown(request,response);
                break;
            case("addCat"): agregarCategoria(request,response);
                break;
        }
    }

    private void editMenu(HttpServletRequest request, HttpServletResponse response) {
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

            try {
                Class.forName(driver).newInstance();
                Session session = HibernateUtil.getInstance().getSession();
                String selected = request.getParameter("id");
                if (selected!=null) {
                    Menu menu = (Menu) session.createQuery("from Menu where idArticulo= " + selected + " ").uniqueResult();
                    String nombre = request.getParameter("nombre");
                    String precio = request.getParameter("precio");
                    String state = "";
                    if (nombre != null && nombre != "" && precio != null && precio != "") {
                        menu.setNombre(nombre);
                        menu.setPrecio(Integer.parseInt(precio));
                        tx = session.beginTransaction();
                        session.saveOrUpdate(menu);
                        tx.commit();
                        state = "ok";
                    } else{
                        precio = ""+menu.getPrecio();
                        nombre = menu.getNombre();
                    }
                    String id = ""+menu.getIdArticulo();
                    String art = "{ \"state\": \"" + state + "\", \"precio\": \"" + precio + "\",\"nombre\":\""+nombre+"\",\"id\":\""+id+"\" }";
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
                String id = request.getParameter("id");
                if (id!=null ) {

                    Menu menu = (Menu) session.createQuery("from Menu where idArticulo= " + id + " ").uniqueResult();
                    String cat = menu.getCategoria();
                    String nombre = menu.getNombre();
                    int precio = menu.getPrecio();


                        tx = session.beginTransaction();
                        session.delete(menu);
                        tx.commit();

                        List<Menu> menus = (List<Menu>) session.createQuery("from Menu where categoria= '" + cat + "' ").list();

                        if (menus.isEmpty()) {
                            Transaction tx2 = session.beginTransaction();
                            Categoria categoria = (Categoria) session.createQuery("from Categoria where nombre= '" + cat + "' ").uniqueResult();
                            session.delete(categoria);
                            tx2.commit();
                        }
                    String status = "ok";
                    String newMenu = "{ \"nombre\": \"" + nombre + "\",\"categoria\": \"" + cat + "\", \"precio\": \"" + precio +
                            "\",\"id\": \"" + id + "\",\"status\":\""+status+"\"}";
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

            } else {
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

                List<Menu> menusCat = session.createQuery("from Menu where categoria='" + categoria + "'").list();
                menusCat.sort(Comparator.comparing(Menu::getIndex));
                int index = 1;
                if (menusCat.size() !=0) {
                    index = menusCat.get(menusCat.size() - 1).getIndex();
                }
                tx = session.beginTransaction();
                Menu menu = new Menu();
                menu.setCategoria(categoriaT);
                menu.setNombre(nombre);
                menu.setPrecio(precio);
                menu.setIndex(index+1);
                session.saveOrUpdate(menu);
                tx.commit();
                int id = menu.getIdArticulo();

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

    private void moveSelectedUp(HttpServletRequest request, HttpServletResponse response){
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        try {
            Class.forName(driver).newInstance();

            Session session = HibernateUtil.getInstance().getSession();
            String id = request.getParameter("id");

            if (id!=null && !id.equals("")){
                Menu menu = (Menu) session.createQuery("from Menu where idArticulo= " + id + " ").uniqueResult();
                String cat = menu.getCategoria();
                List<Menu> menus = session.createQuery("from Menu where categoria='"+cat+"'").list();
                menus.sort(Comparator.comparing(Menu::getIndex));
                int index  = menu.getIndex();
                Menu upMenu = menus.get(menus.indexOf(menu)-1);

                menu.setIndex(upMenu.getIndex());
                upMenu.setIndex(index);
                tx = session.beginTransaction();
                session.saveOrUpdate(menu);
                session.saveOrUpdate(upMenu);
                tx.commit();
                String nombreUp = menu.getNombre();
                int precioUp = menu.getPrecio();
                int precioDown = upMenu.getPrecio();
                String nombreDown = upMenu.getNombre();
                int idDown = upMenu.getIdArticulo();
                String status = "ok";

                String newMenu = "{ \"nombreUp\": \"" + nombreUp + "\",\"nombreDown\": \"" + nombreDown + "\", \"precioUp\": \"" + precioUp + "\",\"idUp\": \"" + id +
                        "\",\"precioDown\":\""+precioDown+"\",\"idDown\":\""+idDown+"\",\"status\":\""+status+"\"}";
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

    private void moveSelectedDown(HttpServletRequest request, HttpServletResponse response){
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        try {
            Class.forName(driver).newInstance();

            Session session = HibernateUtil.getInstance().getSession();
            String id = request.getParameter("id");

            if (id!=null && !id.equals("")){
                Menu menu = (Menu) session.createQuery("from Menu where idArticulo= " + id + " ").uniqueResult();
                String cat = menu.getCategoria();
                List<Menu> menus = session.createQuery("from Menu where categoria='"+cat+"'").list();
                menus.sort(Comparator.comparing(Menu::getIndex));
                int index  = menu.getIndex();
                Menu downMenu = menus.get(menus.indexOf(menu)+1);

                menu.setIndex(downMenu.getIndex());
                downMenu.setIndex(index);
                tx = session.beginTransaction();
                session.saveOrUpdate(menu);
                session.saveOrUpdate(downMenu);
                tx.commit();

                String nombreUp = downMenu.getNombre();
                int precioUp = downMenu.getPrecio();
                int precioDown = menu.getPrecio();
                String nombreDown = menu.getNombre();
                int idUp = downMenu.getIdArticulo();
                String status = "ok";

                String newMenu = "{ \"nombreUp\": \"" + nombreUp + "\",\"nombreDown\": \"" + nombreDown + "\", \"precioUp\": \"" + precioUp + "\",\"idUp\": \"" + idUp +
                        "\",\"precioDown\":\""+precioDown+"\",\"idDown\":\""+id+"\",\"status\":\""+status+"\"}";
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

    private void agregarCategoria(HttpServletRequest request, HttpServletResponse response){
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        try {
            Class.forName(driver).newInstance();

            Session session = HibernateUtil.getInstance().getSession();
            String nombre = request.getParameter("name").toUpperCase();
            if (nombre == null || nombre == "" ){
                nombre = "vacio";
                String newMenu = "{ \"nombre\": \"" + nombre +"\"}";
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(newMenu);
                out.flush();

            } else {

                Categoria categoria = (Categoria) session.createQuery("from Categoria where nombre='" + nombre + "'").uniqueResult();
                if (categoria == null) {
                    tx = session.beginTransaction();
                    Categoria nuevaCat = new Categoria();
                    nuevaCat.setNombre(nombre);
                    session.saveOrUpdate(nuevaCat);
                    tx.commit();
                    String newCat = "{ \"nombre\": \"" + nombre + "\"}";
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print(newCat);
                    out.flush();

                }else{
                    nombre = "repeat";
                    String newMenu = "{ \"nombre\": \"" + nombre +"\"}";
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print(newMenu);
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
}

