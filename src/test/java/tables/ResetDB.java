package tables;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;

/**
 * Created by Tomas on 5/26/2016.
 */
public class ResetDB {
    private static SessionFactory factory;

    public static void main(String[] args) throws Exception {
        factory = HibernateUtil.getInstance().getSession().getSessionFactory();
        addArticulo("papas",20,"principal");
        addArticulo("agua",10,"bebida");
        addArticulo("coca",15,"bebida");
        addArticulo("milanesa",80,"principal");
        addMesa("mesa1","No pide asistencia","1");
        addMesa("mesa2","No pide asistencia","2");
        addMesa("mesa3","No pide asistencia","3");
        factory.close();
    }

    private static void addArticulo( String nombre, int precio, String cat) {
        Session session = factory.openSession();
        Transaction tx = null;
        try {


            String categoria = (String) session.createQuery("select Nombre from Categoria where Nombre='"+ cat.toUpperCase() +"'").uniqueResult();
            if(categoria == null){
                tx = session.beginTransaction();
                Categoria c = new Categoria();
                c.setNombre(cat.toUpperCase());
                session.saveOrUpdate(c);
                tx.commit();
                categoria = cat.toUpperCase();
            }

            tx = session.beginTransaction();
            Menu menu = new Menu();
            menu.setCategoria(categoria);
            menu.setNombre(nombre);
            menu.setPrecio(precio);
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
