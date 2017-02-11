package tables;

import javax.persistence.*;

/**
 * Created by AlumnosFI on 15/06/2016.
 */
@Entity
@Table(name= "Administrador")
public class Administrador {
    @Id
    @GeneratedValue
    @Column(name = "id")
    private Integer id;


    @Column(name = "name")
    private String name;
    @Column(name = "password")
    private String password;


    public void setName(String id) {
        this.name = id;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public String getPassword() {
        return password;
    }
}
