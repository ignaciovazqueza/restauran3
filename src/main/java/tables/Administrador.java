package tables;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by AlumnosFI on 15/06/2016.
 */
@Entity
@Table(name= "Administrador")
public class Administrador {
    @Id
    @Column(name = "id")
    private String id;
    @Column(name = "password")
    private String password;


    public void setId(String id) {
        this.id = id;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getId() {
        return id;
    }

    public String getPassword() {
        return password;
    }
}
