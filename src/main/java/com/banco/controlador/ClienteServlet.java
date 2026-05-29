package com.banco.controlador;

import com.banco.dao.ClienteDAO;
import com.banco.modelo.Cliente;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ClienteServlet", urlPatterns = {"/ClienteServlet"})
public class ClienteServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            // 1. Capturar parámetros del formulario de dashboard_cajero.jsp
            String dui = request.getParameter("txtDui");
            String nombre = request.getParameter("txtNombre");
            double salario = Double.parseDouble(request.getParameter("txtSalario"));
            
            // 2. Armar el objeto Modelo
            Cliente nuevoCliente = new Cliente();
            nuevoCliente.setNombre(nombre);
            nuevoCliente.setDui(dui);
            nuevoCliente.setSalario(salario);
            nuevoCliente.setEstado("Activo");

            // 3. Ejecutar inserción a través del DAO (Llamando al método que crea la cuenta)
            ClienteDAO clienteDAO = new ClienteDAO();
            String cuentaCreada = clienteDAO.registrarClienteConCuenta(nuevoCliente);

            // 4. Redireccionar mandando el número de cuenta generado a la vista
            if (cuentaCreada != null) {
                response.sendRedirect("dashboard_cajero.jsp?tab=clientes&status_cliente=success&cuenta_asignada=" + cuentaCreada);
            } else {
                response.sendRedirect("dashboard_cajero.jsp?tab=clientes&status_cliente=error");
            }
            
        } catch (Exception e) {
            response.setContentType("text/html;charset=UTF-8");
            try (java.io.PrintWriter out = response.getWriter()) {
                out.println("<h3>Error al procesar el alta del cliente:</h3>");
                out.println("<p>Detalle técnico: <strong>" + e.toString() + "</strong></p>");
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