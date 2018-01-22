package websockets;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@ServerEndpoint("/pedido")
public class PedidoWebSocket {

    private static Set<Session> clients =
            Collections.synchronizedSet(new HashSet<Session>());

    @OnMessage
    public void onMessage(String message, Session session)
            throws IOException {

        synchronized(clients){
            for(Session client : clients){
                if (!client.equals(session)){
                    client.getBasicRemote().sendText(message);
                }
            }
        }

    }

    @OnOpen
    public void onOpen (Session session) {
        // Add session to the connected sessions set
        clients.add(session);
    }

    @OnClose
    public void onClose (Session session) {
        // Remove session from the connected sessions set
        clients.remove(session);
    }

    @OnError
    public void onError(Session session, Throwable thr) {
        thr.getMessage();
    }
}
