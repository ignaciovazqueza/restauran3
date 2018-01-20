package tables;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by Tomas on 3/29/2016.
 */

@Entity
@Table (name = "Categoria")
public class Categoria {

    @Id
    @Column(name = "nombre")
    private String nombre;

    @Column(name = "index")
    private int index;

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }
}
