package tables;

import javax.persistence.*;

/**
 * Created by Tomas on 3/29/2016.
 */
@Entity
@Table(name= "Orden")
public class Orden {
    @Id
    @GeneratedValue
    @Column(name = "idOrden")
    private Integer idorden;
    @Column(name = "idMesa")
    private String idMesa;
    @Column(name = "estado")
    private String estado;

    public void setIdMesa(String idMesa) {
        this.idMesa = idMesa;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public int getIdorden() {
        return idorden;
    }

    public String getIdMesa() {
        return idMesa;
    }

    public String getEstado() {
        return estado;
    }

}