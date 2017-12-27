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
    @Column(name = "Nombre")
    private String Nombre;
    @Column(name = "Index")
    private int Index;

    public String getNombre() {
        return Nombre;
    }
    public int getIndex() { return Index;}

    public void setNombre(String nombre) {
        this.Nombre = nombre;
    }
    public void setIndex (int index) { this.Index = index; }
}
