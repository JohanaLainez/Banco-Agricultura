package com.banco.controlador;

import com.banco.dao.TransaccionDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "TransaccionServlet", urlPatterns = {"/TransaccionServlet"})
public class TransaccionServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            // 1. Capturar los parámetros enviados por el formulario de Caja
            String dui = request.getParameter("txtDui");
            String numeroCuenta = request.getParameter("txtNumeroCuenta");
            String tipo = request.getParameter("cmbTipoTransaccion"); // 'Deposito' o 'Retiro'
            double monto = Double.parseDouble(request.getParameter("txtMonto"));

            // 2. Invocar la lógica del DAO con las validaciones requeridas de base de datos
            TransaccionDAO transaccionDAO = new TransaccionDAO();
            String resultado = transaccionDAO.procesarTransaccionVentanilla(dui, numeroCuenta, tipo, monto);

            // 3. Evaluar el resultado transaccional y redirigir al dashboard con alertas dinámicas
            if (resultado.equals("SUCCESS")) {
                response.sendRedirect("dashboard_cajero.jsp?tab=caja&status=success");
            } else if (resultado.startsWith("ERROR_VALIDACION")) {
                // Mandamos el mensaje de error de MySQL bien estructurado en la URL
                response.sendRedirect("dashboard_cajero.jsp?tab=caja&status=error_validacion&msg=" + java.net.URLEncoder.encode(resultado.substring(18), "UTF-8"));
            } else if (resultado.startsWith("ERROR_FONDOS")) {
                response.sendRedirect("dashboard_cajero.jsp?tab=caja&status=error_fondos&msg=" + java.net.URLEncoder.encode(resultado.substring(13), "UTF-8"));
            }

        } catch (Exception e) {
            // Pantalla de auxilio por si ocurre una falla crítica de conversión o nulos
            response.setContentType("text/html;charset=UTF-8");
            try (java.io.PrintWriter out = response.getWriter()) {
                out.println("<h3>Error Crítico en el Controlador de Ventanilla:</h3>");
                out.println("<p>Detalle técnico: <strong>" + e.toString() + "</strong></p>");
                out.println("<p>Asegúrate de que el DAO tenga el método procesarTransaccionVentanilla.</p>");
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