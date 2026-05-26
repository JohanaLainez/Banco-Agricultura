package com.banco.dao;

import com.banco.conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TransaccionDAO {

    public boolean abonarEfectivo(String numeroCuenta, double monto) {
        if (monto <= 0) {
            return false;
        }

        String actualizarSaldo = "UPDATE cuentas SET saldo = saldo + ? WHERE numero_cuenta = ?";
        String insertarTransaccion = "INSERT INTO transacciones (tipo, monto, id_cuenta) "
                                   + "VALUES ('Deposito', ?, (SELECT id_cuenta FROM cuentas WHERE numero_cuenta = ?))";

        try (Connection conn = Conexion.getConexion()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(actualizarSaldo);
                 PreparedStatement ps2 = conn.prepareStatement(insertarTransaccion)) {

                ps1.setDouble(1, monto);
                ps1.setString(2, numeroCuenta);

                int filasActualizadas = ps1.executeUpdate();

                if (filasActualizadas == 0) {
                    conn.rollback();
                    return false;
                }

                ps2.setDouble(1, monto);
                ps2.setString(2, numeroCuenta);
                ps2.executeUpdate();

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean retirarEfectivo(String numeroCuenta, double monto) {
        if (monto <= 0) {
            return false;
        }

        String consultarSaldo = "SELECT saldo FROM cuentas WHERE numero_cuenta = ?";
        String actualizarSaldo = "UPDATE cuentas SET saldo = saldo - ? WHERE numero_cuenta = ?";
        String insertarTransaccion = "INSERT INTO transacciones (tipo, monto, id_cuenta) "
                                   + "VALUES ('Retiro', ?, (SELECT id_cuenta FROM cuentas WHERE numero_cuenta = ?))";

        try (Connection conn = Conexion.getConexion()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psSaldo = conn.prepareStatement(consultarSaldo)) {
                psSaldo.setString(1, numeroCuenta);

                try (ResultSet rs = psSaldo.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }

                    double saldoActual = rs.getDouble("saldo");

                    if (saldoActual < monto) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement ps1 = conn.prepareStatement(actualizarSaldo);
                 PreparedStatement ps2 = conn.prepareStatement(insertarTransaccion)) {

                ps1.setDouble(1, monto);
                ps1.setString(2, numeroCuenta);
                ps1.executeUpdate();

                ps2.setDouble(1, monto);
                ps2.setString(2, numeroCuenta);
                ps2.executeUpdate();

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}