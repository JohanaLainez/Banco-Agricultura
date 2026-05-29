package com.banco.dao;

import com.banco.conexion.Conexion;
import com.banco.modelo.Empleado;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO {

    // 1. VALIDAR EL LOGIN (Solo deja entrar a los que ya están 'Activo')
    public Empleado validarLogin(String user, String password) {
        Connection con = Conexion.getConexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Empleado emp = null;

        String sql = "SELECT * FROM empleados WHERE usuario = ? AND clave = ? AND estado = 'Activo'";

        try {
            ps = con.prepareStatement(sql);
            ps.setString(1, user);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                emp = new Empleado();
                emp.setIdEmpleado(rs.getInt("id_empleado"));
                emp.setNombre(rs.getString("nombre"));
                emp.setDui(rs.getString("dui"));
                emp.setUsuario(rs.getString("usuario"));
                emp.setRol(rs.getString("rol"));
                emp.setSucursal(rs.getString("sucursal"));
                emp.setDireccion(rs.getString("direccion"));
                emp.setTelefono(rs.getString("telefono"));
                emp.setEstado(rs.getString("estado"));
            }
        } catch (SQLException e) {
            System.out.println("Error en Login: " + e.getMessage());
        } finally {
            closeResources(con, ps, rs);
        }
        return emp;
    }

    // 2. REGISTRAR PROPUESTA DE EMPLEADO (Inicia como 'Pendiente' con dirección y teléfono)
    public boolean registrarEmpleado(Empleado emp) {
        Connection con = Conexion.getConexion();
        PreparedStatement ps = null;
        String sql = "INSERT INTO empleados (nombre, dui, usuario, clave, rol, sucursal, direccion, telefono, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pendiente')";
        
        try {
            ps = con.prepareStatement(sql);
            ps.setString(1, emp.getNombre());
            ps.setString(2, emp.getDui());
            ps.setString(3, emp.getUsuario());
            ps.setString(4, emp.getClave());
            ps.setString(5, emp.getRol());
            ps.setString(6, emp.getSucursal());
            ps.setString(7, emp.getDireccion());
            ps.setString(8, emp.getTelefono());
            
            int resultado = ps.executeUpdate();
            return resultado > 0;
        } catch (SQLException e) {
            System.out.println("Error al registrar empleado: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, ps, null);
        }
    }

    // 3. LISTAR TODAS LAS SOLICITUDES PENDIENTES (Para la tabla del Gerente General)
    public List<Empleado> obtenerPendientes() {
        List<Empleado> lista = new ArrayList<>();
        Connection con = Conexion.getConexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM empleados WHERE estado = 'Pendiente'";

        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Empleado emp = new Empleado();
                emp.setIdEmpleado(rs.getInt("id_empleado"));
                emp.setNombre(rs.getString("nombre"));
                emp.setDui(rs.getString("dui"));
                emp.setUsuario(rs.getString("usuario"));
                emp.setRol(rs.getString("rol"));
                emp.setSucursal(rs.getString("sucursal"));
                emp.setDireccion(rs.getString("direccion"));
                emp.setTelefono(rs.getString("telefono"));
                emp.setEstado(rs.getString("estado"));
                lista.add(emp);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar pendientes: " + e.getMessage());
        } finally {
            closeResources(con, ps, rs);
        }
        return lista;
    }

    // 4. CAMBIAR EL ESTADO (Para Aceptar o Rechazar desde el Panel General)
    public boolean actualizarEstado(int idEmpleado, String nuevoEstado) {
        Connection con = Conexion.getConexion();
        PreparedStatement ps = null;
        String sql = "UPDATE empleados SET estado = ? WHERE id_empleado = ?";
        
        try {
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idEmpleado);
            
            // Si pasa a activo, le generamos un usuario automático basado en su nombre
            if(nuevoEstado.equals("Activo")) {
                String sqlUser = "UPDATE empleados SET usuario = LOWER(REPLACE(nombre, ' ', '.')), clave = '123' WHERE id_empleado = ?";
                PreparedStatement ps2 = con.prepareStatement(sqlUser);
                ps2.setInt(1, idEmpleado);
                ps2.executeUpdate();
                ps2.close();
            }

            int resultado = ps.executeUpdate();
            return resultado > 0;
        } catch (SQLException e) {
            System.out.println("Error al actualizar estado: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, ps, null);
        }
    }

    private void closeResources(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            System.out.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
}