package com.banco.dao;

import com.banco.conexion.Conexion;
import com.banco.modelo.Sucursal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class SucursalDAO {

    public boolean registrarSucursal(Sucursal suc) throws SQLException { // Agregamos throws SQLException aquí
        Connection con = Conexion.getConexion();
        PreparedStatement ps = null;
        String sql = "INSERT INTO sucursales (nombre_sucursal, codigo_sucursal, direccion, nombre_gerente, presupuesto_inicial, cajas_disponibles) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            if (con == null) {
                throw new SQLException("La conexión a la base de datos es NULA. Revisa tu clase Conexion.");
            }
            
            ps = con.prepareStatement(sql);
            ps.setString(1, suc.getNombreSucursal());
            ps.setString(2, suc.getCodigoSucursal());
            ps.setString(3, suc.getDireccion());
            ps.setString(4, suc.getNombreGerente());
            ps.setDouble(5, suc.getPresupuestoInicial());
            ps.setInt(6, suc.getCajasDisponibles());
            
            int resultado = ps.executeUpdate();
            return resultado > 0;
        } catch (SQLException e) {
            System.out.println("Error al registrar sucursal: " + e.getMessage());
            throw e; // Lanzamos el error para que el Servlet lo atrape y lo muestre en pantalla
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos en SucursalDAO: " + e.getMessage());
            }
        }
    }
}