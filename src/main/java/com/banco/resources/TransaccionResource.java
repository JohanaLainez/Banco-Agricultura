package com.banco.resources;

import com.banco.dao.TransaccionDAO;
import com.banco.modelo.OperacionRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/")
public class TransaccionResource {

    private final TransaccionDAO transaccionDAO = new TransaccionDAO();

    @POST
    @Path("/abonarefectivo")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response abonarEfectivo(OperacionRequest request) {
        boolean resultado = transaccionDAO.abonarEfectivo(
                request.getNumeroCuenta(),
                request.getMonto()
        );

        if (resultado) {
            return Response.ok("{\"mensaje\":\"Abono realizado correctamente\"}").build();
        }

        return Response.status(Response.Status.BAD_REQUEST)
                .entity("{\"mensaje\":\"No se pudo realizar el abono\"}")
                .build();
    }

    @POST
    @Path("/retirarefectivo")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response retirarEfectivo(OperacionRequest request) {
        boolean resultado = transaccionDAO.retirarEfectivo(
                request.getNumeroCuenta(),
                request.getMonto()
        );

        if (resultado) {
            return Response.ok("{\"mensaje\":\"Retiro realizado correctamente\"}").build();
        }

        return Response.status(Response.Status.BAD_REQUEST)
                .entity("{\"mensaje\":\"No se pudo realizar el retiro. Verifique saldo o número de cuenta\"}")
                .build();
    }
}