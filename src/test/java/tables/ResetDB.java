package tables;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;

import java.util.List;

/**
 * Created by Tomas on 5/26/2016.
 */
public class ResetDB {
    private static SessionFactory factory;

    public static void main(String[] args) throws Exception {
        factory = HibernateUtil.getInstance().getSession().getSessionFactory();
        addArticulo("Milanesa de carne",80,"principal",1);
        addArticulo("Milanesa de pollo",80,"principal",2);
        addArticulo("Papas fritas",20,"principal",3);
        addArticulo("Agua",10,"bebida",1);
        addArticulo("Coca-Cola",12,"bebida",2);
        addArticulo("Sprite",12,"bebida",3);
        addArticulo("Fanta",12,"bebida",4);
        addArticulo("Helado de frutilla",25,"postre",1);
        addArticulo("Helado de vainilla",25,"postre",2);
        addArticulo("Flan con dulce de leche",25,"postre",3);
        addMesa("mesa1","No pide asistencia","1");
        addMesa("mesa2","No pide asistencia","2");
        addMesa("mesa3","No pide asistencia","3");
        factory.close();
    }

    private static void addArticulo( String nombre, int precio, String cat, int index) {
        Session session = factory.openSession();
        Transaction tx = null;
        try {


            String categoria = (String) session.createQuery("select nombre from Categoria where nombre='"+ cat.toUpperCase() +"'").uniqueResult();


            if(categoria == null){
                List categoriaList = session.createQuery("from Categoria ").list();
                int catIndex= 1;
                if (categoriaList.size() !=0) {
                    catIndex = categoriaList.size() + 1;
                }
                tx = session.beginTransaction();
                Categoria c = new Categoria();
                c.setNombre(cat.toUpperCase());
                c.setIndex(catIndex);
                session.saveOrUpdate(c);
                tx.commit();
                categoria = cat.toUpperCase();
            }

            tx = session.beginTransaction();
            Menu menu = new Menu();
            menu.setCategoria(categoria);
            menu.setNombre(nombre);
            menu.setPrecio(precio);
            menu.setIndex(index);
            session.saveOrUpdate(menu);
            tx.commit();
        } catch (HibernateException e) {
            if (tx!= null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    private static void addMesa(String idMesa, String asistencia, String token) {
        Session session = factory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            Mesa mesa = new Mesa();
            mesa.setMesa(idMesa);
            mesa.setToken(token);
            mesa.setAsistencia(asistencia);
            session.saveOrUpdate(mesa);
            tx.commit();
        } catch (HibernateException e) {
            if (tx!= null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }
}
