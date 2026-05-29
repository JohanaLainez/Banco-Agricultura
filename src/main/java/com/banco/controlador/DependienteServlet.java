package com.banco.controlador;

import com.banco.dao.DependienteDAO;
import com.banco.modelo.Dependiente;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DependienteServlet", urlPatterns = {"/DependienteServlet"})
public class DependienteServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Capturar los inputs del formulario del jsp
            String duiTitular = request.getParameter("txtDuiTitular");
            String nombre = request.getParameter("txtNombreDependiente");
            String parentesco = request.getParameter("txtParentesco");

            // Mapear al modelo
            Dependiente d = new Dependiente();
            d.setDuiTitular(duiTitular);
            d.setNombre(nombre);
            d.setParentesco(parentesco);

            // Guardar usando el DAO
            DependienteDAO dao = new DependienteDAO();
            boolean exito = dao.vincularDependiente(d);

            if(exito) {
                // Redirige manteniendo la pestaña de dependientes activa con alerta verde
                response.sendRedirect("dashboard_cajero.jsp?tab=dependientes&status_dependiente=success");
            } else {
                response.sendRedirect("dashboard_cajero.jsp?tab=dependientes&status_dependiente=error");
            }
            
        } catch (Exception e) {
            response.sendRedirect("dashboard_cajero.jsp?tab=dependientes&status_dependiente=error");
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