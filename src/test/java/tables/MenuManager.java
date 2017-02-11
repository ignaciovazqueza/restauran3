package tables;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;

/**
 * Created by Tomas on 4/11/2016.
 */
public class MenuManager {
    private static SessionFactory factory;

    public static void main(String[] args) throws Exception {
        factory = HibernateUtil.getInstance().getSession().getSessionFactory();
        addArticulo(1,"pan",5,"entrada");
        addArticulo(2,"agua",10,"bebida");
        addArticulo(3,"milanesa",80,"principal");
        factory.close();
    }

    private static void addArticulo(int idArticulo, String nombre, int precio, String categoria) {
        Session session = factory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            Menu menu = new Menu();
            menu.setCategoria(categoria);
            menu.setIdArticulo(idArticulo);
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
}
