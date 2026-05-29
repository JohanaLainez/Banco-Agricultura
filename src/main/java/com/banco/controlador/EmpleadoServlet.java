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

        // CASO A: VIENE DEL GERENTE DE SUCURSAL (REGISTRAR)
        if (accion == null) {
            String nombre = request.getParameter("txtNombre");
            String dui = request.getParameter("txtDui");
            String rol = request.getParameter("cmbRol");
            String sucursal = request.getParameter("cmbSucursal");
            String direccion = request.getParameter("txtDireccion");
            String telefono = request.getParameter("txtTelefono");

            Empleado nuevo = new Empleado();
            nuevo.setNombre(nombre);
            nuevo.setDui(dui);
            nuevo.setRol(rol);
            nuevo.setSucursal(sucursal);
            nuevo.setDireccion(direccion);
            nuevo.setTelefono(telefono);
            // Valores provisionales obligatorios para la BD antes de ser aprobados
            nuevo.setUsuario(dui); 
            nuevo.setClave("123");

            boolean OK = empleadoDAO.registrarEmpleado(nuevo);
            if (OK) {
                response.sendRedirect("dashboard_gerente.jsp?status=success");
            } else {
                response.sendRedirect("dashboard_gerente.jsp?status=error");
            }
        } 
        // CASO B: VIENE DEL GERENTE GENERAL (ACEPTAR O RECHAZAR)
        else {
            int id = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = accion.equals("aceptar") ? "Activo" : "Rechazado";
            
            boolean OK = empleadoDAO.actualizarEstado(id, nuevoEstado);
            response.sendRedirect("dashboard_general.jsp?update=" + (OK ? "success" : "error"));
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