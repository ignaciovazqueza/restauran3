package tables;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by Tomas on 3/29/2016.
 */
@Entity
@Table(name= "Mesa")
public class Mesa {

    @Id
    @Column(name = "mesa")
    private String mesa;
    @Column(name = "token")
    private String token;
    @Column(name = "asistencia")
    private String asistencia;

    public void setMesa(String mesa) {
        this.mesa = mesa;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getMesa() {
        return mesa;
    }

    public String getToken() {
        return token;
    }

    public String getAsistencia() {
        return asistencia;
    }

    public void setAsistencia(String asistencia) {
        this.asistencia = asistencia;
    }
}
