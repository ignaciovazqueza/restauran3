package tables;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;

/**
 * Created by Tomas on 4/11/2016.
 */
public class MesaManager {
    private static SessionFactory factory;

    public static void main(String[] args) throws Exception {
        factory = HibernateUtil.getInstance().getSession().getSessionFactory();
        addMesa("1","mesa1");
        factory.close();
    }

    private static void addMesa(String idMesa, String token) {
        Session session = factory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            Mesa mesa = new Mesa();
            mesa.setMesa(idMesa);
            mesa.setToken(token);
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