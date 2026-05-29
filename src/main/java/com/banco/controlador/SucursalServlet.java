package com.banco.controlador;

import com.banco.dao.SucursalDAO;
import com.banco.modelo.Sucursal;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "SucursalServlet", urlPatterns = {"/SucursalServlet"})
public class SucursalServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            // 1. Capturar los 6 campos del formulario
            String nombreSucursal = request.getParameter("txtNombreSucursal");
            String codigoSucursal = request.getParameter("txtCodigoSucursal");
            String direccion = request.getParameter("txtDireccion");
            String nombreGerente = request.getParameter("txtNombreGerente");
            
            // Conversión segura de números
            double presupuesto = Double.parseDouble(request.getParameter("txtPresupuesto"));
            int cajas = Integer.parseInt(request.getParameter("txtCajas"));

            // 2. Armar el modelo
            Sucursal nuevaSucursal = new Sucursal();
            nuevaSucursal.setNombreSucursal(nombreSucursal);
            nuevaSucursal.setCodigoSucursal(codigoSucursal);
            nuevaSucursal.setDireccion(direccion);
            nuevaSucursal.setNombreGerente(nombreGerente);
            nuevaSucursal.setPresupuestoInicial(presupuesto);
            nuevaSucursal.setCajasDisponibles(cajas);

            // 3. Insertar en la BD mediante el DAO
            SucursalDAO sucursalDAO = new SucursalDAO();
            boolean guardado = sucursalDAO.registrarSucursal(nuevaSucursal);

            // 4. Redirigir de vuelta al panel general directo a la pestaña de sucursales
            if (guardado) {
                response.sendRedirect("dashboard_general.jsp?tab=sucursales&status_sucursal=success");
            } else {
                response.sendRedirect("dashboard_general.jsp?tab=sucursales&status_sucursal=error");
            }
            
        } catch (Exception e) {
            // SALVAVIDAS: Si el código se interrumpe por nulos o formatos, imprime el error exacto en pantalla
            response.setContentType("text/html;charset=UTF-8");
            try (java.io.PrintWriter out = response.getWriter()) {
                out.println("<h3>Ocurrió un error en el Servlet de Sucursales:</h3>");
                out.println("<p>Detalle del error: <strong>" + e.toString() + "</strong></p>");
                out.println("<p>Asegúrate de que los atributos 'name' del JSP coincidan exactamente con el servlet.</p>");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
} 