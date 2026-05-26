package com.banco.resources;

import com.banco.dao.CuentaDAO;
import com.banco.modelo.Cuenta;
import java.util.List;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/cuentas")
public class CuentaResource {

    private final CuentaDAO cuentaDAO = new CuentaDAO();

    @GET
    @Path("/{dui}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response obtenerCuentasPorDui(@PathParam("dui") String dui) {
        List<Cuenta> cuentas = cuentaDAO.obtenerCuentasPorDui(dui);

        if (cuentas.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("No se encontraron cuentas para el DUI ingresado")
                    .build();
        }

        return Response.ok(cuentas).build();
    }
}