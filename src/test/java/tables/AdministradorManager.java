//package tables;
//
//import org.hibernate.HibernateException;
//import org.hibernate.Session;
//import org.hibernate.SessionFactory;
//import org.hibernate.Transaction;
//import securityfilter.util.HibernateUtil;
//
///**
// * Created by Tomas on 3/29/2016.
// */
//public class AdministradorManager {
//
//    private static SessionFactory factory;
//
//    public static void main(String[] args) throws Exception {
//        factory = HibernateUtil.getInstance().getSession().getSessionFactory();
//        addAdministrador("admin","123");
//        factory.close();
//    }
//
//    private static void addAdministrador(String idAdmin, String password) {
//        Session session = factory.openSession();
//        Transaction tx = null;
//        try {
//            tx = session.beginTransaction();
//            Administrador administrador = new Administrador();
//            administrador.setIdAdmin(idAdmin);
//            administrador.setPassword(password);
//            session.saveOrUpdate(administrador);
//            tx.commit();
//        } catch (HibernateException e) {
//            if (tx!= null) tx.rollback();
//            e.printStackTrace();
//        } finally {
//            session.close();
//        }
//    }
//}