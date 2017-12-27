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

    @Column(name = "Precio")
    private int Precio;

    @Column(name = "Nombre")
    private String Nombre;

    @Column(name = "Categoria")
    private String Categoria;

    @Column(name = "Index")
    private int Index;

    public int getIdArticulo() {
        return idArticulo;
    }

    public void setIdArticulo(int idArticulo) {
        this.idArticulo = idArticulo;
    }

    public String getCategoria() {
        return Categoria;
    }

    public void setCategoria(String categoria) {
        this.Categoria = categoria;
    }

    public String getNombre() {
        return Nombre;
    }

    public void setNombre(String nombre) {
        this.Nombre = nombre;
    }

    public int getPrecio() {
        return Precio;
    }

    public void setPrecio(int precio) {
        this.Precio = precio;
    }

    public int getIndex() {
        return Index;
    }

    public void setIndex(int index) {
        this.Index = index;
    }

}
