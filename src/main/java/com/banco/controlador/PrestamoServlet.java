package com.banco.controlador;

import com.banco.dao.PrestamoDAO;
import com.banco.modelo.Prestamo;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PrestamoServlet", urlPatterns = {"/PrestamoServlet"})
public class PrestamoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            String dui = request.getParameter("txtDui");
            double salario = Double.parseDouble(request.getParameter("txtSalario"));
            double monto = Double.parseDouble(request.getParameter("txtMonto"));
            
            double maxMonto = 0.0;
            double tasaInteres = 0.0;
            int plazoAnos = 5; // Asumimos un plazo estándar de 5 años para el ejercicio

            // 1. APLICACIÓN DE POLÍTICAS DE CRÉDITO SEGÚN SALARIO
            if (salario < 365) {
                maxMonto = 10000.0;
                tasaInteres = 0.03; // 3%
            } else if (salario < 600) {
                maxMonto = 25000.0;
                tasaInteres = 0.03; // 3%
            } else if (salario < 900) {
                maxMonto = 35000.0;
                tasaInteres = 0.04; // 4%
            } else {
                maxMonto = 50000.0;
                tasaInteres = 0.05; // 5%
            }

            // Regla 1: Validar Monto Máximo Autorizado
            if (monto > maxMonto) {
                response.sendRedirect("dashboard_cajero.jsp?tab=prestamos&status_prestamo=error_monto&max=" + maxMonto);
                return;
            }

            // 2. CÁLCULO FINANCIERO DE LA CUOTA MENSUAL
            double totalInteres = monto * tasaInteres * plazoAnos;
            double totalAPagar = monto + totalInteres;
            double cuotaMensual = totalAPagar / (plazoAnos * 12);

            // Regla 2: Validar Capacidad de Pago (Máximo 30% del salario)
            double capacidadMaxima = salario * 0.30;
            if (cuotaMensual > capacidadMaxima) {
                response.sendRedirect("dashboard_cajero.jsp?tab=prestamos&status_prestamo=error_capacidad&cuota=" + String.format("%.2f", cuotaMensual));
                return;
            }

            // 3. PASÓ FILTROS: Mapear y registrar en estado 'en espera'
            Prestamo p = new Prestamo();
            p.setDuiCliente(dui);
            p.setMontoSolicitado(monto);
            p.setInteresAplicado(tasaInteres * 100); // Guardamos el entero (3, 4 o 5)
            p.setCuotaMensual(cuotaMensual);
            p.setPlazoAnos(plazoAnos);
            p.setEstado("en espera");

            PrestamoDAO dao = new PrestamoDAO();
            if (dao.registrarSolicitud(p)) {
                response.sendRedirect("dashboard_cajero.jsp?tab=prestamos&status_prestamo=success");
            } else {
                response.sendRedirect("dashboard_cajero.jsp?tab=prestamos&status_prestamo=error_db");
            }

        } catch (Exception e) {
            response.sendRedirect("dashboard_cajero.jsp?tab=prestamos&status_prestamo=error_critico");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}