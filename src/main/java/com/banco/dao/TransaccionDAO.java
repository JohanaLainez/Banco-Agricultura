package com.banco.dao;

import com.banco.conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TransaccionDAO {

    // =========================================================================
    // 1. MÉTODO PARA EL CAJERO (VENTANILLA CON VALIDACIÓN DE DUI)
    // =========================================================================
    public String procesarTransaccionVentanilla(String dui, String numeroCuenta, String tipo, double monto) throws SQLException {
        Connection con = Conexion.getConexion();
        PreparedStatement psValidar = null;
        PreparedStatement psActualizarSaldo = null;
        PreparedStatement psInsertarTransaccion = null;
        ResultSet rs = null;

        String sqlValidar = "SELECT c.id_cuenta, c.saldo FROM cuentas c "
                          + "INNER JOIN clientes cl ON c.id_cliente = cl.id_cliente "
                          + "WHERE cl.dui = ? AND c.numero_cuenta = ?";

        try {
            if (con == null) throw new SQLException("Error: Conexión nula a la base de datos.");
            con.setAutoCommit(false);

            psValidar = con.prepareStatement(sqlValidar);
            psValidar.setString(1, dui);
            psValidar.setString(2, numeroCuenta);
            rs = psValidar.executeQuery();

            if (!rs.next()) {
                con.rollback();
                return "ERROR_VALIDACION: El DUI ingresado no está relacionado con ese número de cuenta.";
            }

            int idCuenta = rs.getInt("id_cuenta");
            double saldoActual = rs.getDouble("saldo");
            double nuevoSaldo = saldoActual;

            if (tipo.equalsIgnoreCase("Retiro")) {
                if (saldoActual < monto) {
                    con.rollback();
                    return "ERROR_FONDOS: Saldo insuficiente en la cuenta. Saldo disponible: $" + saldoActual;
                }
                nuevoSaldo = saldoActual - monto;
            } else if (tipo.equalsIgnoreCase("Deposito")) {
                nuevoSaldo = saldoActual + monto;
            }

            String sqlActualizar = "UPDATE cuentas SET saldo = ? WHERE id_cuenta = ?";
            psActualizarSaldo = con.prepareStatement(sqlActualizar);
            psActualizarSaldo.setDouble(1, nuevoSaldo);
            psActualizarSaldo.setInt(2, idCuenta);
            psActualizarSaldo.executeUpdate();

            String sqlInsertar = "INSERT INTO transacciones (tipo, monto, id_cuenta) VALUES (?, ?, ?)";
            psInsertarTransaccion = con.prepareStatement(sqlInsertar);
            psInsertarTransaccion.setString(1, tipo);
            psInsertarTransaccion.setDouble(2, monto);
            psInsertarTransaccion.setInt(3, idCuenta);
            psInsertarTransaccion.executeUpdate();

            con.commit();
            return "SUCCESS";

        } catch (SQLException e) {
            if (con != null) con.rollback();
            System.out.println("Error en la transacción: " + e.getMessage());
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (psValidar != null) psValidar.close();
            if (psActualizarSaldo != null) psActualizarSaldo.close();
            if (psInsertarTransaccion != null) psInsertarTransaccion.close();
            if (con != null) con.close();
        }
    }

    // =========================================================================
    // 2. MÉTODO REQUERIDO POR TRANSACCIONRESOURCE (REST API - ABONAR)
    // =========================================================================
    public boolean abonarEfectivo(String numeroCuenta, double monto) {
        Connection con = Conexion.getConexion();
        PreparedStatement psId = null;
        PreparedStatement psUp = null;
        PreparedStatement psIns = null;
        ResultSet rs = null;
        
        try {
            if (con == null) return false;
            con.setAutoCommit(false);
            
            String sqlId = "SELECT id_cuenta, saldo FROM cuentas WHERE numero_cuenta = ?";
            psId = con.prepareStatement(sqlId);
            psId.setString(1, numeroCuenta);
            rs = psId.executeQuery();
            
            if (rs.next()) {
                int idCuenta = rs.getInt("id_cuenta");
                double saldoActual = rs.getDouble("saldo");
                
                String sqlUp = "UPDATE cuentas SET saldo = ? WHERE id_cuenta = ?";
                psUp = con.prepareStatement(sqlUp);
                psUp.setDouble(1, saldoActual + monto);
                psUp.setInt(2, idCuenta);
                psUp.executeUpdate();
                
                String sqlIns = "INSERT INTO transacciones (tipo, monto, id_cuenta) VALUES ('Deposito', ?, ?)";
                psIns = con.prepareStatement(sqlIns);
                psIns.setDouble(1, monto);
                psIns.setInt(2, idCuenta);
                psIns.executeUpdate();
                
                con.commit();
                return true;
            }
            con.rollback();
            return false;
        } catch (SQLException e) {
            try { if(con != null) con.rollback(); } catch(Exception ex){}
            System.out.println("Error en abonarEfectivo API: " + e.getMessage());
            return false;
        } finally {
            try {
                if(rs != null) rs.close();
                if(psId != null) psId.close();
                if(psUp != null) psUp.close();
                if(psIns != null) psIns.close();
                if(con != null) con.close();
            } catch(Exception e){}
        }
    }

    // =========================================================================
    // 3. MÉTODO REQUERIDO POR TRANSACCIONRESOURCE (REST API - RETIRAR)
    // =========================================================================
    public boolean retirarEfectivo(String numeroCuenta, double monto) {
        Connection con = Conexion.getConexion();
        PreparedStatement psId = null;
        PreparedStatement psUp = null;
        PreparedStatement psIns = null;
        ResultSet rs = null;
        
        try {
            if (con == null) return false;
            con.setAutoCommit(false);
            
            String sqlId = "SELECT id_cuenta, saldo FROM cuentas WHERE numero_cuenta = ?";
            psId = con.prepareStatement(sqlId);
            psId.setString(1, numeroCuenta);
            rs = psId.executeQuery();
            
            if (rs.next()) {
                int idCuenta = rs.getInt("id_cuenta");
                double saldoActual = rs.getDouble("saldo");
                
                if (saldoActual < monto) {
                    con.rollback();
                    return false; 
                }
                
                String sqlUp = "UPDATE cuentas SET saldo = ? WHERE id_cuenta = ?";
                psUp = con.prepareStatement(sqlUp);
                psUp.setDouble(1, saldoActual - monto);
                psUp.setInt(2, idCuenta);
                psUp.executeUpdate();
                
                String sqlIns = "INSERT INTO transacciones (tipo, monto, id_cuenta) VALUES ('Retiro', ?, ?)";
                psIns = con.prepareStatement(sqlIns);
                psIns.setDouble(1, monto);
                psIns.setInt(2, idCuenta);
                psIns.executeUpdate();
                
                con.commit();
                return true;
            }
            con.rollback();
            return false;
        } catch (SQLException e) {
            try { if(con != null) con.rollback(); } catch(Exception ex){}
            System.out.println("Error en retirarEfectivo API: " + e.getMessage());
            return false;
        } finally {
            try {
                if(rs != null) rs.close();
                if(psId != null) psId.close();
                if(psUp != null) psUp.close();
                if(psIns != null) psIns.close();
                if(con != null) con.close();
            } catch(Exception e){}
        }
    }

    // =========================================================================
    // 4. HISTORIAL GLOBAL PARA AUDITORÍA (VERSIÓN OPTIMIZADA EN MATRICES)
    // =========================================================================
    public java.util.List<String[]> obtenerHistorialGlobal() {
        java.util.List<String[]> lista = new java.util.ArrayList<>();
        Connection con = Conexion.getConexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT t.id_transaccion, c.numero_cuenta, t.tipo, t.monto FROM transacciones t "
                   + "INNER JOIN cuentas c ON t.id_cuenta = c.id_cuenta ORDER BY t.id_transaccion DESC";

        try {
            if (con != null) {
                ps = con.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String[] registro = new String[4];
                    registro[0] = String.valueOf(rs.getInt("id_transaccion"));
                    registro[1] = rs.getString("numero_cuenta");
                    registro[2] = rs.getString("tipo");
                    registro[3] = String.valueOf(rs.getDouble("monto"));
                    lista.add(registro);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener auditoría global: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {}
        }
        return lista;
    }
}