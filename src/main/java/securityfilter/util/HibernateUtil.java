package securityfilter.util;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

/**
 * Created by matias on 13/4/16.
 */
public class HibernateUtil {

    private final Session session;

    public HibernateUtil() {
        try {
            final SessionFactory factory = new Configuration().configure().buildSessionFactory();
            session = factory.openSession();
        } catch (Throwable ex) {
            System.err.println("Failed to create sessionFactory object. " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public Session getSession() { return session; }

    private static HibernateUtil instance;

    public static HibernateUtil getInstance() {
        if(instance == null) instance = new HibernateUtil();
        return instance;
    }
}
