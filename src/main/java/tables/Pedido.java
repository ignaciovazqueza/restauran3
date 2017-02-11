package tables;

import javax.persistence.*;

/**
 * Created by Tomas on 3/29/2016.
 */
@Entity
@Table(name= "Pedido")
public class Pedido {
    @Id

    @GeneratedValue
    @Column(name = "idPedido")
    private Integer idPedido;
    @Column(name = "idOrden")
    private int idOrden;
    @Column(name = "idArticulo")
    private int idArticulo;
    @Column(name = "cantidad")
    private String cantidad;
    @Column(name = "entregado")
    private String entregado;

    public void setIdPedido(Integer idPedido) {
        this.idPedido = idPedido;
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public int getIdOrden() {
        return idOrden;
    }

    public void setIdOrden(int idOrden) {
        this.idOrden = idOrden;
    }

    public int getIdArticulo() {
        return idArticulo;
    }

    public void setIdArticulo(int idArticulo) {
        this.idArticulo = idArticulo;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getEntregado() {
        return entregado;
    }

    public void setEntregado(String entregado) {
        this.entregado = entregado;
    }
}
