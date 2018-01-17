package tables;

import javax.persistence.*;

/**
 * Created by Tomas on 3/29/2016.
 */

@Entity
@Table(name= "Menu")
public class Menu {

    @Id
    @GeneratedValue
    @Column(name = "idArticulo")
    private Integer idArticulo;

    @Column(name = "precio")
    private int precio;

    @Column(name = "index")
    private int index;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "categoria")
    private String categoria;

    public int getIdArticulo() {
        return idArticulo;
    }

    public void setIdArticulo(int idArticulo) {
        this.idArticulo = idArticulo;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getPrecio() {
        return precio;
    }

    public void setPrecio(int precio) {
        this.precio = precio;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

}
