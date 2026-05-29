package com.banco.dao;

import com.banco.conexion.Conexion;
import com.banco.modelo.Prestamo;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class PrestamoDAO {

    public boolean registrarSolicitud(Prestamo p) {
        String sql = "INSERT INTO prestamos (dui_cliente, monto_solicitado, interes_aplicado, cuota_mensual, plazo_anos, estado) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, p.getDuiCliente());
            ps.setDouble(2, p.getMontoSolicitado());
            ps.setDouble(3, p.getInteresAplicado());
            ps.setDouble(4, p.getCuotaMensual());
            ps.setInt(5, p.getPlazoAnos());
            ps.setString(6, p.getEstado());
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.out.println("Error en PrestamoDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}