package securityfilter;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.hibernate.Session;
import org.hibernate.Transaction;
import securityfilter.util.HibernateUtil;
import tables.Administrador;
import tables.Categoria;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Created by AlumnosFI on 04/05/2016.
 */
public class AdminValues {
    InputStream inputStream;
    private String user = "";
    private String password = "";

    public String getUser() throws IOException {

        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            Administrador admin = (Administrador) session.createQuery("from Administrador" ).uniqueResult();
            if (admin==null) {
                Properties prop = new Properties();
                String propFileName = "config.properties";
                inputStream = getClass().getClassLoader().getResourceAsStream(propFileName);

                if (inputStream != null) {
                    prop.load(inputStream);
                    inputStream.close();
                } else {
                    throw new FileNotFoundException("property file '" + propFileName + "' not found in the classpath");
                }
                user = prop.getProperty("username");
            }else{
                user=  admin.getId();
            }

        } catch (Exception e) {
            System.out.println("Exception: " + e);
        }
        return user;
    }

    public String getPassword() throws IOException {
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        try {
            Class.forName(driver).newInstance();
            Session session = HibernateUtil.getInstance().getSession();
            Properties prop = new Properties();
            String propFileName = "config.properties";
            inputStream = getClass().getClassLoader().getResourceAsStream(propFileName);
            Administrador admin = (Administrador) session.createQuery("from Administrador" ).uniqueResult();
            if (admin==null) {
                if (inputStream != null) {
                    prop.load(inputStream);
                } else {
                    throw new FileNotFoundException("property file '" + propFileName + "' not found in the classpath");
                }
                password = prop.getProperty("password");
            }else{
                password = admin.getPassword();
            }
        } catch (Exception e) {
            System.out.println("Exception: " + e);
        } finally {
            inputStream.close();
        }

        return password;
    }

    public void setUser(String newUser) throws Exception {
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        Class.forName(driver).newInstance();
        Session session = HibernateUtil.getInstance().getSession();
        Administrador admin = (Administrador) session.createQuery("from Administrador" ).uniqueResult();
        if (admin==null) {
            tx = session.beginTransaction();
            Administrador newAdmin = new Administrador();
            newAdmin.setId(newUser);
            newAdmin.setPassword(getPassword());
            session.saveOrUpdate(newAdmin);
            tx.commit();

        }else{
            tx = session.beginTransaction();
            admin.setId(newUser);
            session.saveOrUpdate(admin);
            tx.commit();
        }


    }

    public void setPassword(String pass) throws Exception {
        String driver = "org.hsqldb.jdbc.JDBCDriver";
        Transaction tx = null;

        Class.forName(driver).newInstance();
        Session session = HibernateUtil.getInstance().getSession();
        Administrador admin = (Administrador) session.createQuery("from Administrador" ).uniqueResult();

        if (admin==null) {
            tx = session.beginTransaction();
            Administrador newAdmin = new Administrador();
            newAdmin.setId(getUser());
            newAdmin.setPassword(pass);
            session.saveOrUpdate(newAdmin);
            tx.commit();
        }else {
            tx = session.beginTransaction();
            admin.setPassword(pass);
            session.saveOrUpdate(admin);
            tx.commit();
        }
    }

}

