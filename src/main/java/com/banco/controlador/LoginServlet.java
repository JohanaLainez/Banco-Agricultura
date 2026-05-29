package com.banco.controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.banco.dao.EmpleadoDAO;
import com.banco.modelo.Empleado;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capturamos los parámetros que vienen del index.html
        String txtUser = request.getParameter("txtUsuario");
        String txtPass = request.getParameter("txtClave");
        
        EmpleadoDAO empleadoDAO = new EmpleadoDAO();
        
        // 2. Evaluamos contra la base de datos de MySQL
        Empleado empleado = empleadoDAO.validarLogin(txtUser, txtPass);
        
        if (empleado != null) {
            // 3. Si existe y está activo, le creamos una sesión en el navegador
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", empleado);
            
            // 4. Leemos su rol para saber a qué pantalla mandarlo de una sola vez
            String rol = empleado.getRol();
            
            if (rol.equals("Gerente General")) {
                response.sendRedirect("dashboard_general.jsp");
            } else if (rol.equals("Gerente de Sucursal")) {
                response.sendRedirect("dashboard_gerente.jsp");
            } else if (rol.equals("Cajero")) {
                response.sendRedirect("dashboard_cajero.jsp");
            } else {
                response.sendRedirect("index.html?error=rol_no_reconocido");
            }
            
        } else {
            // 5. Si los datos están erróneos o el usuario está pendiente, lo regresa al login
            response.sendRedirect("index.html?error=credenciales_incorrectas");
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