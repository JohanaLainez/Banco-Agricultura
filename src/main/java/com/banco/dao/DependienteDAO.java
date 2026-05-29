package com.banco.dao;

import com.banco.conexion.Conexion;
import com.banco.modelo.Dependiente;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class DependienteDAO {
    
    public boolean vincularDependiente(Dependiente d) {
        String sql = "INSERT INTO dependientes (dui_titular, nombre, parentesco) VALUES (?, ?, ?)";
        
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, d.getDuiTitular());
            ps.setString(2, d.getNombre());
            ps.setString(3, d.getParentesco());
            
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (Exception e) {
            System.out.println("Error en DependienteDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}