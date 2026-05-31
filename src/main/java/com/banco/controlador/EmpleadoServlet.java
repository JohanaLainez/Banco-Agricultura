package com.banco.controlador;

import com.banco.dao.EmpleadoDAO;
import com.banco.modelo.Empleado;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EmpleadoServlet", urlPatterns = {"/EmpleadoServlet"})
public class EmpleadoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        EmpleadoDAO empleadoDAO = new EmpleadoDAO();
        String accion = request.getParameter("accion");

        // CASO A: VIENE DEL GERENTE DE SUCURSAL (NUEVA PANTALLA)
        if ("registrar".equals(accion)) {
            Empleado nuevo = new Empleado();
            // Usamos los nombres exactos del HTML del dashboard_gerente.jsp
            nuevo.setDui(request.getParameter("dui"));
            nuevo.setNombre(request.getParameter("nombre"));
            nuevo.setRol(request.getParameter("rol"));
            nuevo.setSucursal(request.getParameter("sucursal"));
            nuevo.setDireccion(request.getParameter("direccion"));
            nuevo.setTelefono(request.getParameter("telefono"));
            nuevo.setEstado("Pendiente"); // OBLIGATORIO: Va a espera
            nuevo.setUsuario(request.getParameter("usuario"));
            nuevo.setClave(request.getParameter("clave"));

            // Llamamos al método de tu DAO original
            boolean OK = empleadoDAO.registrarEmpleado(nuevo);
            
            if (OK) {
                response.sendRedirect("dashboard_gerente.jsp?status=success");
            } else {
                response.sendRedirect("dashboard_gerente.jsp?status=error");
            }
        } 
        // CASO B: VIENE DEL GERENTE GENERAL (ACEPTAR O RECHAZAR PENDIENTES)
        else if ("aceptar".equals(accion) || "rechazar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = accion.equals("aceptar") ? "Activo" : "Rechazado";
            
            boolean OK = empleadoDAO.actualizarEstado(id, nuevoEstado);
            response.sendRedirect("dashboard_general.jsp?update=" + (OK ? "success" : "error"));
        }
        else {
             // Si entra sin acción, lo mandamos al inicio
             response.sendRedirect("index.html");
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